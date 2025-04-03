docker run --rm \
  --platform linux/amd64 \
  -v jekyll_gem_cache:/usr/local/bundle \
  -v "$PWD:/srv/jekyll" \
  -p 4100:4000 \
  -p 35730:35729 \
  jekyll/jekyll:4.2.2 \
  bash -c "bundle config set path /usr/local/bundle && jekyll serve --livereload --port 4000 --livereload-port 35729"

