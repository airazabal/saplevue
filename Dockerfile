# production stage
FROM nginx:1.13.12-alpine as production-stage
COPY /vueapp01/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]