<div style="display: flex; flex-flow: column; align-items: center;">
  <img src="nginx/config/html/nginx-more.svg" width="80px"/>
  <p style="font-size: 30px; font-weight: bold">nginx-more</p>
</div>

# Description

Built from source alpine based nginx with extra features.

Check [0-install-deps.alpine.sh](nginx/0-install-deps.alpine.sh) for build options. Nginx `access` and `error` logs piped to `stderr` and `stdout` to check them in docker logs. Also, no additional log rotation needed inside container.

# Dependencies

- nginx@1.25.5
    - pcre2@2.10.43
    - zlib@1.3.1
    - openssl@3.0.7 (alpine)
- [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)@0.37
- [nginx-module-vts](https://github.com/vozlt/nginx-module-vts)@0.2.2

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

Extended metrics available at:

```bash
localhost:9020/status # html
localhost:9020/metrics # prometheus
```

Check `Makefile` for more useful targets

## How to deploy manually

- before commit/merge changes to `main`, bump `latest-version.txt` version and describe changes in `CHANGELOG.md`
- commit/merge changes to main
- create tag = `latest-version.txt`, e.g. `v0.3.0`
- `git push --tags`
- build & push image: `make build && make push`
