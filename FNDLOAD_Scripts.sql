-- tags : FNDLOAD

Usage of FNDLOAD for AOL objects


Following are the usage list of FNDLOAD to upload and download various AOL objects.

Concurrent Program
-------------------
FNDLOAD apps/apps O Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct XXCUST_CP.ldt PROGRAM APPLICATION_SHORT_NAME="XXCUST" CONCURRENT_PROGRAM_NAME="XXCUST_CP"

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct XXCUST_CP.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE

Lookups
-------------------
FNDLOAD apps/apps O Y DOWNLOAD $FND_TOP/patch/115/import/aflvmlu.lct XXCUST_LKP.ldt FND_LOOKUP_TYPE APPLICATION_SHORT_NAME="XXCUST" LOOKUP_TYPE="XXCUST_LKP"

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct  XXCUST_LKP.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE

Message
-------------------
FNDLOAD apps/apps 0 Y DOWNLOAD $FND_TOP/patch/115/import/afmdmsg.lct XXCUST_MESG.ldt FND_NEW_MESSAGES APPLICATION_SHORT_NAME="XXCUST" MESSAGE_NAME="XXCUST_MESG%"

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afmdmsg.lct XXCUST_MESG.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE

Request Set and Link
-------------------
FNDLOAD apps/apps 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcprset.lct XXCUST_RS.ldt REQ_SET REQUEST_SET_NAME='XXCUST_RS'

FNDLOAD apps/apps 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcprset.lct XXCUST_LNK.ldt REQ_SET_LINKS REQUEST_SET_NAME='XXCUST_LNK'


FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct  XXCUST_RS.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct  XXCUST_LNK.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE

Form Function
-------------------
FNDLOAD apps/apps 0 Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct XXCUST_FUNC.ldt FUNCTION FUNC_APP_SHORT_NAME='XXCUST' FUNCTION_NAME='XXCUST_FUNC'

FNDLOAD apps/apps 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct XXCUST_FUNC.ldt

Profile
-------------------
FNDLOAD apps/apps 0 Y DOWNLOAD $FND_TOP/patch/115/import/afscprof.lct XXCUST_PROF.ldt PROFILE PROFILE_NAME="XXCUST_PROFILE" APPLICATION_SHORT_NAME="XXCUST"

FNDLOAD apps/apps 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct XXCUST_FUNC.ldt 

Menu
-------------------
FNDLOAD apps/apps O Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct XXCUST_MENU.ldt MENU MENU_NAME="XXCUST_MENU"

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afsload.lct XXCUST_MENU.ldt

Data Definition
-------------------
FNDLOAD apps/apps 0 Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct XXCUST_DD.ldt XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME=XXCUST DATA_SOURCE_CODE=XXCUST_DS

FNDLOAD apps/apps O Y UPLOAD $FND_TOP/patch/115/import/afsload.lct XXCUST_DD.ldt 