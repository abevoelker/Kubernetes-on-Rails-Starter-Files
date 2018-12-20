# [Kubernetes on Rails](https://KubernetesOnRails.com)

Starter files for the Kubernetes on Rails course. Come [learn Kubernetes](https://KubernetesOnRails.com) with me!

The code in this repo meant to be a reference point for anyone following along with the video course. The [stepped-solutions directory](stepped-solutions) contains the final code at the end of each episode.

## FAQ

### Q: Why aren't you using an Alpine-based Docker parent image?

**A:** Alpine-based Ruby images can have odd bugs, sometimes related to Alpine's use of musl libc instead of glibc ([example](https://github.com/docker-library/ruby/issues/245))
