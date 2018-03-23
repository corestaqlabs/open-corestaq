################################################################################
#
# php
#
################################################################################

FAPSCRIPT_VERSION = 7.2.3
FAPSCRIPT_SITE = http://www.php.net/distributions
FAPSCRIPT_SOURCE = php-$(FAPSCRIPT_VERSION).tar.xz
FAPSCRIPT_INSTALL_STAGING = YES
FAPSCRIPT_INSTALL_STAGING_OPTS = INSTALL_ROOT=$(STAGING_DIR) install
FAPSCRIPT_INSTALL_TARGET_OPTS = INSTALL_ROOT=$(TARGET_DIR) install
FAPSCRIPT_DEPENDENCIES = host-pkgconf
FAPSCRIPT_LICENSE = PHP-3.01
FAPSCRIPT_LICENSE_FILES = LICENSE
FAPSCRIPT_CONF_OPTS = \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info \
	--disable-all \
	--without-pear \
	--with-config-file-path=/etc \
	--disable-phpdbg \
	--disable-rpath
FAPSCRIPT_CONF_ENV = \
	ac_cv_func_strcasestr=yes \
	EXTRA_LIBS="$(FAPSCRIPT_EXTRA_LIBS)"

ifeq ($(BR2_STATIC_LIBS),y)
FAPSCRIPT_CONF_ENV += LIBS="$(FAPSCRIPT_STATIC_LIBS)"
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
FAPSCRIPT_STATIC_LIBS += -lpthread
endif

ifeq ($(call qstrip,$(BR2_TARGET_LOCALTIME)),)
FAPSCRIPT_LOCALTIME = UTC
else
# Not q-stripping this value, as we need quotes in the php.ini file
FAPSCRIPT_LOCALTIME = $(BR2_TARGET_LOCALTIME)
endif

# PHP can't be AUTORECONFed the standard way unfortunately
FAPSCRIPT_DEPENDENCIES += host-autoconf host-automake host-libtool
define FAPSCRIPT_BUILDCONF
	cd $(@D) ; $(TARGET_MAKE_ENV) ./buildconf --force
endef
FAPSCRIPT_PRE_CONFIGURE_HOOKS += FAPSCRIPT_BUILDCONF

ifeq ($(BR2_ENDIAN),"BIG")
FAPSCRIPT_CONF_ENV += ac_cv_c_bigendian_php=yes
else
FAPSCRIPT_CONF_ENV += ac_cv_c_bigendian_php=no
endif
FAPSCRIPT_CONFIG_SCRIPTS = php-config

FAPSCRIPT_CFLAGS = $(TARGET_CFLAGS)
FAPSCRIPT_CXXFLAGS = $(TARGET_CXXFLAGS)

# The OPcache extension isn't cross-compile friendly
# Throw some defines here to avoid patching heavily
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_OPCACHE),y)
FAPSCRIPT_CONF_OPTS += --enable-opcache
FAPSCRIPT_CONF_ENV += ac_cv_func_mprotect=yes
FAPSCRIPT_CFLAGS += \
	-DHAVE_SHM_IPC \
	-DHAVE_SHM_MMAP_ANON \
	-DHAVE_SHM_MMAP_ZERO \
	-DHAVE_SHM_MMAP_POSIX \
	-DHAVE_SHM_MMAP_FILE
endif

# We need to force dl "detection"
ifeq ($(BR2_STATIC_LIBS),)
FAPSCRIPT_CONF_ENV += ac_cv_func_dlopen=yes ac_cv_lib_dl_dlopen=yes
FAPSCRIPT_EXTRA_LIBS += -ldl
else
FAPSCRIPT_CONF_ENV += ac_cv_func_dlopen=no ac_cv_lib_dl_dlopen=no
endif

FAPSCRIPT_CONF_OPTS += $(if $(BR2_PACKAGE_FAPSCRIPT_SAPI_CLI),--enable-cli,--disable-cli)
FAPSCRIPT_CONF_OPTS += $(if $(BR2_PACKAGE_FAPSCRIPT_SAPI_CGI),--enable-cgi,--disable-cgi)
FAPSCRIPT_CONF_OPTS += $(if $(BR2_PACKAGE_FAPSCRIPT_SAPI_FPM),--enable-fpm,--disable-fpm)

ifeq ($(BR2_PACKAGE_FAPSCRIPT_SAPI_APACHE),y)
FAPSCRIPT_DEPENDENCIES += apache
FAPSCRIPT_CONF_OPTS += --with-apxs2=$(STAGING_DIR)/usr/bin/apxs

# Enable thread safety option if Apache MPM is event or worker
ifeq ($(BR2_PACKAGE_APACHE_MPM_EVENT)$(BR2_PACKAGE_APACHE_MPM_WORKER),y)
FAPSCRIPT_CONF_OPTS += --enable-maintainer-zts
endif
endif

### Extensions
FAPSCRIPT_CONF_OPTS += \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SOCKETS),--enable-sockets) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_POSIX),--enable-posix) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SESSION),--enable-session) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_HASH),--enable-hash) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_DOM),--enable-dom) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SIMPLEXML),--enable-simplexml) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SOAP),--enable-soap) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_XML),--enable-xml) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_XMLREADER),--enable-xmlreader) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_XMLWRITER),--enable-xmlwriter) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_EXIF),--enable-exif) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_FTP),--enable-ftp) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_JSON),--enable-json) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_TOKENIZER),--enable-tokenizer) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_PCNTL),--enable-pcntl) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SHMOP),--enable-shmop) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SYSVMSG),--enable-sysvmsg) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SYSVSEM),--enable-sysvsem) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_SYSVSHM),--enable-sysvshm) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_ZIP),--enable-zip) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_CTYPE),--enable-ctype) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_FILTER),--enable-filter) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_CALENDAR),--enable-calendar) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_FILEINFO),--enable-fileinfo) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_BCMATH),--enable-bcmath) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_MBSTRING),--enable-mbstring) \
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_PHAR),--enable-phar)

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_MCRYPT),y)
FAPSCRIPT_CONF_OPTS += --with-mcrypt=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += libmcrypt
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_OPENSSL),y)
FAPSCRIPT_CONF_OPTS += --with-openssl=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += openssl
# openssl needs zlib, but the configure script forgets to link against
# it causing detection failures with static linking
FAPSCRIPT_STATIC_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_LIBXML2),y)
FAPSCRIPT_CONF_ENV += FAPSCRIPT_cv_libxml_build_works=yes
FAPSCRIPT_CONF_OPTS += --enable-libxml --with-libxml-dir=${STAGING_DIR}/usr
FAPSCRIPT_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_WDDX),y)
FAPSCRIPT_CONF_OPTS += --enable-wddx --with-libexpat-dir=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += expat
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_XMLRPC),y)
FAPSCRIPT_CONF_OPTS += \
	--with-xmlrpc \
	$(if $(BR2_PACKAGE_LIBICONV),--with-iconv-dir=$(STAGING_DIR)/usr)
FAPSCRIPT_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)
endif

ifneq ($(BR2_PACKAGE_FAPSCRIPT_EXT_ZLIB)$(BR2_PACKAGE_FAPSCRIPT_EXT_ZIP),)
FAPSCRIPT_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_GETTEXT),y)
FAPSCRIPT_CONF_OPTS += --with-gettext=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += $(TARGET_NLS_DEPENDENCIES)
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_ICONV),y)
ifeq ($(BR2_PACKAGE_LIBICONV),y)
FAPSCRIPT_CONF_OPTS += --with-iconv=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += libiconv
else
FAPSCRIPT_CONF_OPTS += --with-iconv
endif
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_INTL),y)
FAPSCRIPT_CONF_OPTS += --enable-intl --with-icu-dir=$(STAGING_DIR)/usr
FAPSCRIPT_CXXFLAGS += "`$(STAGING_DIR)/usr/bin/icu-config --cxxflags`"
FAPSCRIPT_DEPENDENCIES += icu
# The intl module is implemented in C++, but PHP fails to use
# g++ as the compiler for the final link. As a workaround,
# tell it to link libstdc++.
FAPSCRIPT_EXTRA_LIBS += -lstdc++
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_GMP),y)
FAPSCRIPT_CONF_OPTS += --with-gmp=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += gmp
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_READLINE),y)
FAPSCRIPT_CONF_OPTS += --with-readline=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += readline
endif

### Native SQL extensions
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_MYSQLI),y)
FAPSCRIPT_CONF_OPTS += --with-mysqli
endif
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_SQLITE),y)
FAPSCRIPT_CONF_OPTS += --with-sqlite3=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += sqlite
FAPSCRIPT_STATIC_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs sqlite3`
endif

### PDO
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_PDO),y)
FAPSCRIPT_CONF_OPTS += --enable-pdo
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_PDO_SQLITE),y)
FAPSCRIPT_CONF_OPTS += --with-pdo-sqlite=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += sqlite
FAPSCRIPT_CFLAGS += -DSQLITE_OMIT_LOAD_EXTENSION
endif
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_PDO_MYSQL),y)
FAPSCRIPT_CONF_OPTS += --with-pdo-mysql
endif
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_PDO_POSTGRESQL),y)
FAPSCRIPT_CONF_OPTS += --with-pdo-pgsql=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += postgresql
endif
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_PDO_UNIXODBC),y)
FAPSCRIPT_CONF_OPTS += --with-pdo-odbc=unixODBC,$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += unixodbc
endif
endif

ifneq ($(BR2_PACKAGE_FAPSCRIPT_EXT_MYSQLI)$(BR2_PACKAGE_FAPSCRIPT_EXT_PDO_MYSQL),)
# Set default MySQL unix socket to what the MySQL server is using by default
FAPSCRIPT_CONF_OPTS += --with-mysql-sock=$(MYSQL_SOCKET)
endif

define FAPSCRIPT_DISABLE_PCRE_JIT
	$(SED) '/^#define SUPPORT_JIT/d' $(@D)/ext/pcre/pcrelib/config.h
endef

define FAPSCRIPT_DISABLE_VALGRIND
	$(SED) '/^#define HAVE_VALGRIND/d' $(@D)/main/php_config.h
endef
FAPSCRIPT_POST_CONFIGURE_HOOKS += FAPSCRIPT_DISABLE_VALGRIND

### Use external PCRE if it's available
ifeq ($(BR2_PACKAGE_PCRE),y)
FAPSCRIPT_CONF_OPTS += --with-pcre-regex=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += pcre
else
# The bundled pcre library is not configurable through ./configure options,
# and by default is configured to be thread-safe, so it wants pthreads. So
# we must explicitly tell it when we don't have threads.
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
FAPSCRIPT_CFLAGS += -DSLJIT_SINGLE_THREADED=1
endif
# check ext/pcre/pcrelib/sljit/sljitConfigInternal.h for supported archs
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_arm)$(BR2_armeb)$(BR2_aarch64)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_powerpc)$(BR2_sparc),)
FAPSCRIPT_POST_CONFIGURE_HOOKS += FAPSCRIPT_DISABLE_PCRE_JIT
endif
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_CURL),y)
FAPSCRIPT_CONF_OPTS += --with-curl=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += libcurl
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_XSL),y)
FAPSCRIPT_CONF_OPTS += --with-xsl=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += libxslt
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_BZIP2),y)
FAPSCRIPT_CONF_OPTS += --with-bz2=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += bzip2
endif

### DBA
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_DBA),y)
FAPSCRIPT_CONF_OPTS += --enable-dba
ifneq ($(BR2_PACKAGE_FAPSCRIPT_EXT_DBA_CDB),y)
FAPSCRIPT_CONF_OPTS += --without-cdb
endif
ifneq ($(BR2_PACKAGE_FAPSCRIPT_EXT_DBA_FLAT),y)
FAPSCRIPT_CONF_OPTS += --without-flatfile
endif
ifneq ($(BR2_PACKAGE_FAPSCRIPT_EXT_DBA_INI),y)
FAPSCRIPT_CONF_OPTS += --without-inifile
endif
ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_DBA_DB4),y)
FAPSCRIPT_CONF_OPTS += --with-db4=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += berkeleydb
endif
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_SNMP),y)
FAPSCRIPT_CONF_OPTS += --with-snmp=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += netsnmp
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_EXT_GD),y)
FAPSCRIPT_CONF_OPTS += \
	--with-gd \
	--with-jpeg-dir=$(STAGING_DIR)/usr \
	--with-png-dir=$(STAGING_DIR)/usr \
	--with-zlib-dir=$(STAGING_DIR)/usr \
	--with-freetype-dir=$(STAGING_DIR)/usr
FAPSCRIPT_DEPENDENCIES += jpeg libpng freetype
endif

ifeq ($(BR2_PACKAGE_FAPSCRIPT_SAPI_FPM),y)
define FAPSCRIPT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(@D)/sapi/fpm/init.d.php-fpm \
		$(TARGET_DIR)/etc/init.d/S49php-fpm
endef

define FAPSCRIPT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/sapi/fpm/php-fpm.service \
		$(TARGET_DIR)/usr/lib/systemd/system/php-fpm.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/php-fpm.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/php-fpm.service
endef

define FAPSCRIPT_INSTALL_FPM_CONF
	$(INSTALL) -D -m 0644 package/php/php-fpm.conf \
		$(TARGET_DIR)/etc/php-fpm.conf
	rm -f $(TARGET_DIR)/etc/php-fpm.conf.default
	# remove unused sample status page /usr/php/php/fpm/status.html
	rm -rf $(TARGET_DIR)/usr/php
endef

FAPSCRIPT_POST_INSTALL_TARGET_HOOKS += FAPSCRIPT_INSTALL_FPM_CONF
endif

define FAPSCRIPT_EXTENSIONS_FIXUP
	$(SED) "/prefix/ s:/usr:$(STAGING_DIR)/usr:" \
		$(STAGING_DIR)/usr/bin/phpize
	$(SED) "/extension_dir/ s:/usr:$(TARGET_DIR)/usr:" \
		$(STAGING_DIR)/usr/bin/php-config
endef

FAPSCRIPT_POST_INSTALL_TARGET_HOOKS += FAPSCRIPT_EXTENSIONS_FIXUP

define FAPSCRIPT_INSTALL_FIXUP
	rm -rf $(TARGET_DIR)/usr/lib/php/build
	rm -f $(TARGET_DIR)/usr/bin/phpize
	$(INSTALL) -D -m 0755 $(FAPSCRIPT_DIR)/php.ini-production \
		$(TARGET_DIR)/etc/php.ini
	$(SED) 's%;date.timezone =.*%date.timezone = $(FAPSCRIPT_LOCALTIME)%' \
		$(TARGET_DIR)/etc/php.ini
	$(if $(BR2_PACKAGE_FAPSCRIPT_EXT_OPCACHE),
		$(SED) '/;extension=FAPSCRIPT_xsl.dll/azend_extension=opcache.so' \
		$(TARGET_DIR)/etc/php.ini)
endef

FAPSCRIPT_POST_INSTALL_TARGET_HOOKS += FAPSCRIPT_INSTALL_FIXUP

FAPSCRIPT_CONF_ENV += CFLAGS="$(FAPSCRIPT_CFLAGS)" CXXFLAGS="$(FAPSCRIPT_CXXFLAGS)"

$(eval $(autotools-package))
