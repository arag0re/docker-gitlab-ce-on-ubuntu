# docker-gitlab-ce-on-ubuntu

## quick guide how to build this dockerfile
1.  install dependencies via your package-manager of choice, for me its homebrew: 
```
brew install --cask docker-desktop
```
2. then open a terminal/shell and navigate to the cloned project folder called "gitlab-ce-on-ubuntu"
3. execute docker build command: 
```
docker build --label gitlab-ce-on-ubuntu --tag gitlab-ce-on-ubuntu
```