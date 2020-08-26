# Complains Monorepo

## Notes

- Backend made with mongodb as recomended (run with: `podman run -d --name mongodb -p 27017:27017 mongo`)
- Tests on complains-server/test, run with mix test
- Docs can be generated with `mix docs` on complains-server
- Brainstorm is the initial idea, but currently I dont have more free time

## Deploy

You have 3 options to deploy the backend server:

1 - Just put the compiled BEAM on each server and configure using the BEAM shells

2 - Make a dockerfile and use kubernets to scale the compiled BEAM (just use this: https://www.freecodecamp.org/news/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882/ )

keep in mind that one server (c5.4xlarge) can handle 30k transactions per second (and if you use the channels... well...)
