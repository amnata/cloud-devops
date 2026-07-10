# Use the official Node.js 14 image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the application code
COPY . .

# Expose the port
EXPOSE 3000

# Start the Node.js app
CMD ["node", "server.js"]

