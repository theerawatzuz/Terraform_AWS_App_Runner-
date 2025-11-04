const http = require("http");
const version = process.env.APP_VERSION || "v1";
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end(`Hello!! from App Runner version NTBX ${version}!\n`);
});

server.listen(port, () => {
  console.log(`Server running on port ${port}, version ${version}`);
});
