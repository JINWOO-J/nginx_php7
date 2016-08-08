REPO = dr.ytlabs.co.kr
REPO_HUB = jinwoo
NAME = nginx_php7
VERSION = 7.0.9
#include ENVAR

.PHONY: all build push test tag_latest release ssh

all: build

build:
		docker build --no-cache --rm=true --build-arg PHP_VERSION=$(VERSION) -t $(NAME):$(VERSION) .

push:
		docker tag -f $(NAME):$(VERSION) $(REPO)/$(NAME):$(VERSION)
		docker push $(REPO)/$(NAME):$(VERSION)

push_hub:
		docker tag -f $(NAME):$(VERSION) $(REPO_HUB)/$(NAME):$(VERSION)
		docker push $(REPO_HUB)/$(NAME):$(VERSION)

tag_latest:
		docker tag -f $(REPO)/$(NAME):$(VERSION) $(REPO)/$(NAME):latest
		docker push $(REPO)/$(NAME):latest

build_hub:
		echo "TRIGGER_KEY" ${TRIGGERKEY}
		git add .
		git commit -m "$(NAME):$(VERSION) by Makefile"
		git tag -a "$(VERSION)" -m "$(VERSION) by Makefile"
		git push origin --tags
		curl -H "Content-Type: application/json" --data '{"build": true,"source_type": "Tag", "source_name": "$(VERSION)"}' -X POST https://registry.hub.docker.com/u/jinwoo/${NAME}/trigger/${TRIGGERKEY}/


init:
		git init
		git add .
		git commit -m "first commit"
		git remote add origin git@github.com:JINWOO-J/$(NAME).git
		git push -u origin master