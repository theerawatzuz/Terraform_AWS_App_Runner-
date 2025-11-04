FROM node:16-alpine

WORKDIR /usr/src/app

# ใส่ package.json ถ้ามี
COPY package*.json ./

RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    elif [ -f package.json ]; then \
      npm install --omit=dev; \
    else \
      echo "No package.json found, skip install"; \
    fi

COPY src/ ./

ENV PORT=3000
EXPOSE 3000
CMD ["node","main.js"]