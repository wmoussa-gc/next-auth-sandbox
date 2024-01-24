FROM node:16.17.0-bullseye-slim
ENV NODE_ENV production

WORKDIR /app
COPY package*.json ./
RUN yarn install --production=true

COPY . .

RUN yarn build

# Lambda web adapter: https://github.com/awslabs/aws-lambda-web-adapter
# The public.ecr.aws/awsguru/aws-lambda-adapter:0.7.0 image reference in the docs has
# been pushed to the public CDS ECR to avoid rate limiting when pulling the image.
COPY --from=public.ecr.aws/cds-snc/aws-lambda-adapter:0.7.0@sha256:00b1441858fb3f4ce3d67882ef6153bacf8ff4bb8bf271750c133667202926af /lambda-adapter /opt/extensions/lambda-adapter
RUN ln -s /tmp ./.next/cache

RUN --mount=type=secret,id=OKTA_OAUTH2_CLIENT_ID \
    sed -i "s/OKTA_OAUTH2_CLIENT_ID=/OKTA_OAUTH2_CLIENT_ID=$(cat /run/secrets/OKTA_OAUTH2_CLIENT_ID)/" .env.production

RUN --mount=type=secret,id=OKTA_OAUTH2_CLIENT_SECRET \
    sed -i "s/OKTA_OAUTH2_CLIENT_SECRET=/OKTA_OAUTH2_CLIENT_SECRET=$(cat /run/secrets/OKTA_OAUTH2_CLIENT_SECRET)/" .env.production

RUN --mount=type=secret,id=NEXTAUTH_SECRET \
    sed -i "s/NEXTAUTH_SECRET=/NEXTAUTH_SECRET=$(cat /run/secrets/NEXTAUTH_SECRET)/" .env.production

EXPOSE 3000
ENTRYPOINT ["yarn", "start"]
