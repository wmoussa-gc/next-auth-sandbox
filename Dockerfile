FROM node:18

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .

# Lambda web adapter: https://github.com/awslabs/aws-lambda-web-adapter
# The public.ecr.aws/awsguru/aws-lambda-adapter:0.7.0 image reference in the docs has
# been pushed to the public CDS ECR to avoid rate limiting when pulling the image.
COPY --from=public.ecr.aws/cds-snc/aws-lambda-adapter:0.7.0@sha256:00b1441858fb3f4ce3d67882ef6153bacf8ff4bb8bf271750c133667202926af /lambda-adapter /opt/extensions/lambda-adapter
RUN ln -s /tmp ./.next/cache

EXPOSE 3000
CMD yarn dev