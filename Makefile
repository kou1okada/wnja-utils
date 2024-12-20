upver=v1.1

all: wnjpn.db

wnjpn.db: src/wnjpn-all.tab src/wnjpn-def.tab src/wnjpn-exe.tab
	-$(RM) -f wnjpn.db
	./mkdb.py

src/wnjpn-all.tab src/wnjpn-def.tab src/wnjpn-exe.tab: upstream/$(upver).tgz
	mkdir -p src
	echo $(notdir $@)
	( cd src; tar xvf ../upstream/$(upver).tgz --strip-components=1 $(upver)/$(notdir $@).gz; gzip -d $(notdir $@).gz )

upstream/$(upver).tgz:
	./get_upstream_release.sh $(upver)

clean:
	-$(RM) -rf wnjpn.db src upstream
