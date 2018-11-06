# [Kubernetes for Rails developers](https://kubernetesforrailsdevelopers.com)

Starter files for the Kubernetes for Rails developers course. Come [learn Kubernetes](https://kubernetesforrailsdevelopers.com) with me!

The code in this repo meant to be a reference point for anyone following along with the video course.

## FAQ

### Q: Why are you using Docker image X instead of an Alpine-based one?

**A:** Alpine-based Ruby images can have odd bugs, sometimes related to Alpine's use of musl libc instead of glibc ([example](https://github.com/docker-library/ruby/issues/245))
