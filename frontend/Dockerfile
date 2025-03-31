FROM node:18

# Set the working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Build the Next.js application
RUN npm run build

# Expose the application port
EXPOSE 8080

# Start the Next.js development server
CMD ["npm", "start"]
