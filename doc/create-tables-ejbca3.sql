
Hypersonic
==========
CREATE TABLE HARDTOKENDATA(TOKENSN VARCHAR(256) NOT NULL PRIMARY KEY,USERNAME VARCHAR(256),CTIME BIGINT NOT NULL,MTIME BIGINT NOT NULL,TOKENTYPE INTEGER NOT NULL,SIGNIFICANTISSUERDN VARCHAR(256),DATA VARBINARY)
CREATE TABLE HARDTOKENISSUERDATA(ID INTEGER NOT NULL PRIMARY KEY,ALIAS VARCHAR(256),CERTIFICATESN VARCHAR(256),CERTISSUERDN VARCHAR(256),DATA VARBINARY)
CREATE TABLE HARDTOKENPROFILEDATA(ID INTEGER NOT NULL PRIMARY KEY,NAME VARCHAR(256),UPDATECOUNTER INTEGER NOT NULL,DATA VARBINARY(1100000))
CREATE TABLE HARDTOKENCERTIFICATEMAP(CERTIFICATEFINGERPRINT VARCHAR(256) NOT NULL PRIMARY KEY,TOKENSN VARCHAR(256))
CREATE TABLE KEYRECOVERYDATA(CERTSN VARCHAR(256),ISSUERDN VARCHAR(256),USERNAME VARCHAR(256),MARKEDASRECOVERABLE BIT NOT NULL,KEYDATA VARCHAR(256),CONSTRAINT PK_KEYRECOVERYDATA PRIMARY KEY(CERTSN,ISSUERDN))
CREATE TABLE ADMINGROUPDATA(PK INTEGER NOT NULL PRIMARY KEY,ADMINGROUPNAME VARCHAR(256),CAID INTEGER NOT NULL)
CREATE TABLE ACCESSRULESDATA(PK INTEGER NOT NULL PRIMARY KEY,ACCESSRULE VARCHAR(256),RULE INTEGER NOT NULL,ISRECURSIVE BIT NOT NULL,ADMINGROUPDATA_ACCESSRULES INTEGER)
CREATE TABLE AUTHORIZATIONTREEUPDATEDATA(PK INTEGER NOT NULL PRIMARY KEY,AUTHORIZATIONTREEUPDATENUMBER INTEGER NOT NULL)
CREATE TABLE ADMINENTITYDATA(PK INTEGER NOT NULL PRIMARY KEY,MATCHWITH INTEGER NOT NULL,MATCHTYPE INTEGER NOT NULL,MATCHVALUE VARCHAR(256),ADMINGROUPDATA_ADMINENTITIES INTEGER)
CREATE TABLE CADATA(CAID INTEGER NOT NULL PRIMARY KEY,NAME VARCHAR(256),SUBJECTDN VARCHAR(256),STATUS INTEGER NOT NULL,EXPIRETIME BIGINT NOT NULL,DATA VARCHAR(256))
CREATE TABLE CERTIFICATEDATA(BASE64CERT VARCHAR(256),FINGERPRINT VARCHAR(256) NOT NULL PRIMARY KEY,SUBJECTDN VARCHAR(256),ISSUERDN VARCHAR(256),CAFINGERPRINT VARCHAR(256),SERIALNUMBER VARCHAR(256),STATUS INTEGER NOT NULL,TYPE INTEGER NOT NULL,USERNAME VARCHAR(256),EXPIREDATE BIGINT NOT NULL,REVOCATIONDATE BIGINT NOT NULL,REVOCATIONREASON INTEGER NOT NULL)
CREATE TABLE CERTIFICATEPROFILEDATA(ID INTEGER NOT NULL PRIMARY KEY,CERTIFICATEPROFILENAME VARCHAR(256),DATA VARBINARY)
CREATE TABLE CRLDATA(CRLNUMBER INTEGER NOT NULL,ISSUERDN VARCHAR(256),FINGERPRINT VARCHAR(256) NOT NULL PRIMARY KEY,CAFINGERPRINT VARCHAR(256),THISUPDATE BIGINT NOT NULL,NEXTUPDATE BIGINT NOT NULL,BASE64CRL VARCHAR(256))
CREATE TABLE LOGCONFIGURATIONDATA(ID INTEGER NOT NULL PRIMARY KEY,LOGCONFIGURATION VARBINARY,LOGENTRYROWNUMBER INTEGER NOT NULL)
CREATE TABLE LOGENTRYDATA(ID INTEGER NOT NULL PRIMARY KEY,ADMINTYPE INTEGER NOT NULL,ADMINDATA VARCHAR(256),CAID INTEGER NOT NULL,MODULE INTEGER NOT NULL,TIME BIGINT NOT NULL,USERNAME VARCHAR(256),CERTIFICATESNR VARCHAR(256),EVENT INTEGER NOT NULL,COMMENT VARCHAR(256))
CREATE TABLE ADMINPREFERENCESDATA(ID VARCHAR(256) NOT NULL PRIMARY KEY,DATA VARBINARY)
CREATE TABLE USERDATA(USERNAME VARCHAR(256) NOT NULL PRIMARY KEY,SUBJECTDN VARCHAR(256),CAID INTEGER NOT NULL,SUBJECTALTNAME VARCHAR(256),SUBJECTEMAIL VARCHAR(256),STATUS INTEGER NOT NULL,TYPE INTEGER NOT NULL,CLEARPASSWORD VARCHAR(256),PASSWORDHASH VARCHAR(256),TIMECREATED BIGINT NOT NULL,TIMEMODIFIED BIGINT NOT NULL,ENDENTITYPROFILEID INTEGER NOT NULL,CERTIFICATEPROFILEID INTEGER NOT NULL,TOKENTYPE INTEGER NOT NULL,HARDTOKENISSUERID INTEGER NOT NULL,KEYSTOREPASSWORD VARCHAR(256),EXTENDEDINFORMATIONDATA VARBINARY)
CREATE TABLE ENDENTITYPROFILEDATA(ID INTEGER NOT NULL PRIMARY KEY,PROFILENAME VARCHAR(256),DATA VARBINARY)
CREATE TABLE GLOBALCONFIGURATIONDATA(CONFIGURATIONID VARCHAR(256) NOT NULL PRIMARY KEY,DATA VARBINARY)
CREATE TABLE HARDTOKENPROPERTYDATA(ID INTEGER NOT NULL,PROPERTY VARCHAR(256) NOT NULL,VALUE VARCHAR(256),CONSTRAINT PK_HARDTOKENPROPERTYDATA PRIMARY KEY(ID,PROPERTY))
CREATE TABLE PUBLISHERDATA(ID INTEGER NOT NULL PRIMARY KEY,NAME VARCHAR(256),UPDATECOUNTER INTEGER NOT NULL,DATA VARCHAR(256))

MySQL
=====
CREATE TABLE accessrulesdata (
    pK int(11) NOT NULL DEFAULT '0',
    accessRule varchar(250) binary NULL DEFAULT NULL,
    rule int(11) NOT NULL DEFAULT '0',
    isRecursive tinyint(4) NOT NULL DEFAULT '0',
    `AdminGroupData_accessRules` int(11) NULL DEFAULT NULL,
    PRIMARY KEY (pK)
);

CREATE TABLE adminentitydata (
    pK int(11) NOT NULL DEFAULT '0',
    matchWith int(11) NOT NULL DEFAULT '0',
    matchType int(11) NOT NULL DEFAULT '0',
    matchValue varchar(250) binary NULL DEFAULT NULL,
    `AdminGroupData_adminEntities` int(11) NULL DEFAULT NULL,
    PRIMARY KEY (pK)
);

CREATE TABLE admingroupdata (
    pK int(11) NOT NULL DEFAULT '0',
    adminGroupName varchar(250) binary NULL DEFAULT NULL,
    cAId int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (pK)
);

CREATE TABLE adminpreferencesdata (
    id varchar(250) binary NOT NULL DEFAULT '',
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE authorizationtreeupdatedata (
    pK int(11) NOT NULL DEFAULT '0',
    authorizationTreeUpdateNumber int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (pK)
);

CREATE TABLE cadata (
    cAId int(11) NOT NULL DEFAULT '0',
    name varchar(250) binary NULL DEFAULT NULL,
    subjectDN varchar(250) binary NULL DEFAULT NULL,
    status int(11) NOT NULL DEFAULT '0',
    expireTime bigint(20) NOT NULL DEFAULT '0',
    data text NULL DEFAULT NULL,
    PRIMARY KEY (cAId)
);

CREATE TABLE certificatedata (
    base64Cert text NULL DEFAULT NULL,
    fingerprint varchar(250) binary NOT NULL DEFAULT '',
    subjectDN varchar(250) binary NULL DEFAULT NULL,
    issuerDN varchar(250) binary NULL DEFAULT NULL,
    cAFingerprint varchar(250) binary NULL DEFAULT NULL,
    serialNumber varchar(250) binary NULL DEFAULT NULL,
    status int(11) NOT NULL DEFAULT '0',
    type int(11) NOT NULL DEFAULT '0',
    username varchar(250) binary NULL DEFAULT NULL,
    expireDate bigint(20) NOT NULL DEFAULT '0',
    revocationDate bigint(20) NOT NULL DEFAULT '0',
    revocationReason int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (fingerprint)
);

CREATE TABLE certificateprofiledata (
    id int(11) NOT NULL DEFAULT '0',
    certificateProfileName varchar(250) binary NULL DEFAULT NULL,
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE crldata (
    cRLNumber int(11) NOT NULL DEFAULT '0',
    issuerDN varchar(250) binary NULL DEFAULT NULL,
    fingerprint varchar(250) binary NOT NULL DEFAULT '',
    cAFingerprint varchar(250) binary NULL DEFAULT NULL,
    thisUpdate bigint(20) NOT NULL DEFAULT '0',
    nextUpdate bigint(20) NOT NULL DEFAULT '0',
    base64Crl text NULL DEFAULT NULL,
    PRIMARY KEY (fingerprint)
);

CREATE TABLE endentityprofiledata (
    id int(11) NOT NULL DEFAULT '0',
    profileName varchar(250) binary NULL DEFAULT NULL,
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE globalconfigurationdata (
    configurationId varchar(250) binary NOT NULL DEFAULT '',
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (configurationId)
);

CREATE TABLE hardtokencertificatemap (
    certificateFingerprint varchar(250) binary NOT NULL DEFAULT '',
    tokenSN varchar(250) binary NULL DEFAULT NULL,
    PRIMARY KEY (certificateFingerprint)
);

CREATE TABLE hardtokendata (
    tokenSN varchar(250) binary NOT NULL DEFAULT '',
    username varchar(250) binary NULL DEFAULT NULL,
    cTime bigint(20) NOT NULL DEFAULT '0',
    mTime bigint(20) NOT NULL DEFAULT '0',
    tokenType int(11) NOT NULL DEFAULT '0',
    significantIssuerDN varchar(250) binary NULL DEFAULT NULL,
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (tokenSN)
);

CREATE TABLE hardtokenissuerdata (
    id int(11) NOT NULL DEFAULT '0',
    alias varchar(250) binary NULL DEFAULT NULL,
    adminGroupId int(11) NOT NULL DEFAULT '0',
    data longblob NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE hardtokenprofiledata (
    id int(11) NOT NULL DEFAULT '0',
    name varchar(250) binary NULL DEFAULT NULL,
    updateCounter int(11) NOT NULL DEFAULT '0',
    data varchar(250) binary NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE hardtokenpropertydata (
    id varchar(250) binary NOT NULL DEFAULT '',
    property varchar(250) binary NOT NULL DEFAULT '',
    value varchar(250) binary NULL DEFAULT NULL,
    PRIMARY KEY (id, property)
);

CREATE TABLE keyrecoverydata (
    certSN varchar(250) binary NOT NULL DEFAULT '',
    issuerDN varchar(250) binary NOT NULL DEFAULT '',
    username varchar(250) binary NULL DEFAULT NULL,
    markedAsRecoverable tinyint(4) NOT NULL DEFAULT '0',
    keyData text NULL DEFAULT NULL,
    PRIMARY KEY (certSN, issuerDN)
);

CREATE TABLE logconfigurationdata (
    id int(11) NOT NULL DEFAULT '0',
    logConfiguration longblob NULL DEFAULT NULL,
    logEntryRowNumber int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (id)
);

CREATE TABLE logentrydata (
    id int(11) NOT NULL DEFAULT '0',
    adminType int(11) NOT NULL DEFAULT '0',
    adminData varchar(250) binary NULL DEFAULT NULL,
    caId int(11) NOT NULL DEFAULT '0',
    module int(11) NOT NULL DEFAULT '0',
    `time` bigint(20) NOT NULL DEFAULT '0',
    username varchar(250) binary NULL DEFAULT NULL,
    certificateSNR varchar(250) binary NULL DEFAULT NULL,
    event int(11) NOT NULL DEFAULT '0',
    comment varchar(250) binary NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE publisherdata (
    id int(11) NOT NULL DEFAULT '0',
    name varchar(250) binary NULL DEFAULT NULL,
    updateCounter int(11) NOT NULL DEFAULT '0',
    data text NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE userdata (
    username varchar(250) binary NOT NULL DEFAULT '',
    subjectDN varchar(250) binary NULL DEFAULT NULL,
    cAId int(11) NOT NULL DEFAULT '0',
    subjectAltName varchar(250) binary NULL DEFAULT NULL,
    subjectEmail varchar(250) binary NULL DEFAULT NULL,
    status int(11) NOT NULL DEFAULT '0',
    type int(11) NOT NULL DEFAULT '0',
    clearPassword varchar(250) binary NULL DEFAULT NULL,
    passwordHash varchar(250) binary NULL DEFAULT NULL,
    timeCreated bigint(20) NOT NULL DEFAULT '0',
    timeModified bigint(20) NOT NULL DEFAULT '0',
    endEntityProfileId int(11) NOT NULL DEFAULT '0',
    certificateProfileId int(11) NOT NULL DEFAULT '0',
    tokenType int(11) NOT NULL DEFAULT '0',
    hardTokenIssuerId int(11) NOT NULL DEFAULT '0',
    keyStorePassword varchar(250) binary NULL DEFAULT NULL,
    extendedInformationData longblob NULL DEFAULT NULL,
    PRIMARY KEY (username)
);