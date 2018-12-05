# I2P in Docker

This is the Java I2P router in Docker.

## Usage
build it yourself, not available on hub.docker. 

i.e: 
`git clone https://github.com/rayures/i2p-docker.git /home/i2p/source`

`cd /home/i2p/source/`

`docker build -t i2p .`

run it:

`docker run -v ~/.i2p:/var/lib/i2p -p 127.0.0.1:4444:4444 -p 127.0.0.1:6668:6668 -p 127.0.0.1:7657:7657 geti2p/i2p`


or use the `compose.example.yml`

### Common problems

If you use Fedora or other selinux enabled OS and get ```mkdir: cannot create directory ‘/var/lib/i2p/.i2p’: Permission denied```, try adding a `:Z` to your volume argument:

```
-v ~/.i2p:/var/lib/i2p:Z
```
As described in the [docker documentation](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label), this should set the selinux labels correctly.
