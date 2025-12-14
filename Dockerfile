FROM node:20-alpine

# Install required OS packages
RUN apk add --no-cache python3 make g++ libc6-compat

# Create directory and copy
WORKDIR /app
COPY strapi-project/ ./

# Install dependencies
RUN npm install

# Build Strapi admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]
