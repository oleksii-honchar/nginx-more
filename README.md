<div style="display: flex; flex-flow: column; align-items: center;">
  <img src="nginx/config/html/nginx-more.svg" width="80px"/>
  <p style="font-size: 30px; font-weight: bold">nginx-more</p>
</div>

# Description
Built from source alpine based nginx with extra features.

Check [0-install-deps.alpine.sh](nginx/0-install-deps.alpine.sh) for build options. Nginx `access` and `error` logs piped to `stderr` and `stdout` to check them in docker logs. Also, no additional log rotation needed inside container.

# Dependencies

- nginx@1.25.2
    - pcre2@2.10.42
    - zlib@1.3
    - openssl@3.0.7 (alpine)
- [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)@0.34

# How to use

Current build contains following configuration options ready to use:
- CORS validation
- default mime-types
- default locations
- common proxy-pass

To start using docker-compose just execute:
  ```bash
  make up
  ```
  Then open `localhost:80` in browser to check it's working.
To build image:
  ```bash
  make build
  ```

Check `Makefile` for more useful targets
