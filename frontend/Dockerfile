FROM node:23.10 AS builder

# Set the working directory
WORKDIR /opt/frontend

# Copy package files
COPY ./package.json ./package-lock.json /opt/frontend/

# Install dependencies
RUN npm clean-install

FROM node:23.10-slim AS runtime
WORKDIR /opt/frontend
ENV NEXT_PUBLIC_API_URL=http://localhost:3001

# Copy application files
COPY --from=builder /opt/frontend/node_modules /opt/frontend/node_modules
COPY ./ /opt/frontend

# Expose the application port
EXPOSE 3000

# Start the Next.js development server
CMD ["npm", "run", "start", "--", "--port", "3000"]