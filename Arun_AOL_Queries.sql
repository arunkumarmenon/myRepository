
--tags : value sets, profile options, responsibility, security rule, DFF segments

--------------------------------------------------------
--------  FND Table Queries  / AOL Objects   -----------
--------------------------------------------------------

-- Check value set values
SELECT ffvs.flex_value_set_id ,
		ffvs.flex_value_set_name ,
		ffvs.description set_description ,
		ffvs.validation_type,
		ffv.*,ffvt.* 
FROM fnd_flex_value_sets ffvs ,
	fnd_flex_values ffv ,
	fnd_flex_values_tl ffvt
WHERE ffvs.flex_value_set_id = ffv.flex_value_set_id
and ffv.flex_value_id = ffvt.flex_value_id
AND ffvt.language = USERENV('LANG')
and flex_value_set_name like 'GECAP-SHARED-US_BLE'
and ffv.flex_value in ('BUSV38RYXP', 'BUSX40RYXP', 'BUSX40SB7P')
ORDER BY flex_value asc


--Get profile option name
select * from apps.fnd_profile_options_vl 
where user_profile_option_name like 'GE%Contract%'

-- Get Profile value
select   fpov.*    
from   apps.fnd_profile_option_values fpov
       ,apps.fnd_profile_options_vl    fpo
WHERE 1=1
AND     fpo.profile_option_id     = fpov.profile_option_id
AND     fpo.user_profile_option_name like 'MO:%Def%Operating Unit'
--and  level_id <> 10003
order by fpov.level_id


--Query to see to which responsibilities a profile is enabled
select fpo.user_profile_option_name, fpov.level_id, fpov.level_value, (select responsibility_name 
                                                                    from APPS.fnd_responsibility_vl
                                                                    where responsibility_id = fpov.level_value) Resp_Name,
       fpov.profile_option_value                                                            
from apps.fnd_profile_option_values  fpov, 
              apps.fnd_profile_options_vl fpo 
where fpo.PROFILE_OPTION_ID = fpov.PROFILE_OPTION_ID
and   fpo.user_profile_option_name like 'PO%Default PO Promise Date from Need By Date%'


----Query to check Profile Values at All Levels
----Pasted from <https://govoracleapps.wordpress.com/category/backend-queries/page/2/> 

SELECT po.profile_option_name “NAME”,
		po.user_profile_option_name,
		DECODE (TO_CHAR (pov.level_id),
		‘10001’, ‘SITE’,
		‘10002’, ‘APP’,
		‘10003’, ‘RESP’,
		‘10005’, ‘SERVER’,
		‘10006’, ‘ORG’,
		‘10004’, ‘USER’,
		‘******’
		) “LEVEL”,
		DECODE (TO_CHAR (pov.level_id),
		‘10001’, ”,
		‘10002’, app.application_short_name,
		‘10003’, rsp.responsibility_key,
		‘10005’, svr.node_name,
		‘10006’, org.NAME,
		‘10004’, usr.user_name,
		‘******’
		) “CONTEXT”,
		pov.profile_option_value “VALUE”
FROM
		apps.fnd_profile_options_vl po,
		apps.fnd_profile_option_values pov,
		apps.fnd_user usr,
		apps.fnd_application app,
		apps.fnd_responsibility rsp,
		apps.fnd_nodes svr,
		apps.hr_operating_units org
WHERE 1 = 1
AND pov.application_id = po.application_id
AND pov.profile_option_id = po.profile_option_id
AND usr.user_id(+) = pov.level_value
AND rsp.application_id(+) = pov.level_value_application_id
AND rsp.responsibility_id(+) = pov.level_value
AND app.application_id(+) = pov.level_value
AND svr.node_id(+) = pov.level_value
AND org.organization_id(+) = pov.level_value
AND po.profile_option_name like ‘Give profile name’
AND po.user_profile_option_name like ‘Give User Profile Name’
ORDER BY “NAME”;









-- All responsibility of OUs
select  fpov.profile_option_value org_id, hou.NAME "ORG_NAME", hou.attribute13 Business, FR.RESPONSIBILITY_NAME      
from   
       APPS.FND_RESPONSIBILITY_VL     fr
       ,apps.fnd_profile_option_values fpov
       ,apps.fnd_profile_options_vl    fpo
       ,apps.hr_organization_units     hou
WHERE 1=1
AND     fpov.level_value          = fr.responsibility_id
AND     fpo.profile_option_id     = fpov.profile_option_id
AND     fpo.user_profile_option_name = 'MO: Operating Unit'
AND     fpov.profile_option_id       = fpo.profile_option_id
AND     hou.organization_id          = TO_NUMBER (fpov.profile_option_value)
AND     fpov.profile_option_value in ('9001',
'9052',
'9053')
order by hou.organization_id , FR.RESPONSIBILITY_NAME

--Responsibilities assigned to all users of an OU
select  fpov.profile_option_value org_id, hou.NAME "ORG_NAME", FU.USER_NAME, FU.DESCRIPTION "USER DESCRIPTION", 
        papf.person_id, papf.full_name, papf.employee_number "SSO", FR.RESPONSIBILITY_NAME      
from    apps.fnd_user                  fu
       ,APPS.FND_USER_RESP_GROUPS      furg
       ,APPS.FND_RESPONSIBILITY_VL     fr
       ,apps.fnd_profile_option_values fpov
       ,apps.fnd_profile_options_vl    fpo
       ,apps.hr_organization_units     hou
       ,apps.per_all_people_f          papf
WHERE 1=1
AND     FU.USER_ID = FURG.USER_ID
AND     FURG.RESPONSIBILITY_ID = FR.RESPONSIBILITY_ID
AND     nvl(FU.END_DATE,sysdate+1) >SYSDATE 
AND     fpov.level_value          = fr.responsibility_id
AND     fpo.profile_option_id     = fpov.profile_option_id
AND     fpo.user_profile_option_name = 'MO: Operating Unit'
AND     fpov.profile_option_id       = fpo.profile_option_id
AND     hou.organization_id          = TO_NUMBER (fpov.profile_option_value)
AND     fpov.profile_option_value  IN ('9085', '9084', '9254')
AND     papf.person_id           = fu.employee_id 
AND     NVL(papf.effective_end_date, sysdate+1) > sysdate
order by hou.organization_id , papf.person_id, FR.RESPONSIBILITY_NAME

--Responsibilities assigned to one user
select  FU.USER_NAME, FU.DESCRIPTION "USER DESCRIPTION", 
        papf.person_id, papf.full_name, papf.employee_number "SSO", FR.RESPONSIBILITY_NAME      
from    apps.fnd_user                  fu
       ,APPS.FND_USER_RESP_GROUPS      furg
       ,apps.per_all_people_f          papf
       ,APPS.FND_RESPONSIBILITY_VL     fr
WHERE 1=1
AND     FU.USER_ID = FURG.USER_ID
AND     FURG.RESPONSIBILITY_ID = FR.RESPONSIBILITY_ID
AND     nvl(FU.END_DATE,sysdate+1) >SYSDATE 
AND     papf.person_id           = fu.employee_id 
AND     NVL(papf.effective_end_date, sysdate+1) > sysdate
AND     user_name = '200020674'
order by papf.person_id, FR.RESPONSIBILITY_NAME


-------------------------------------------------------------------------------
-- Query to find GL Flexfield security rule assignments to responsibilities
-------------------------------------------------------------------------------
SELECT distinct a.application_name          "Application Name",
       fvr.flex_value_rule_name    "Flex Value Rule",
       r.responsibility_key        "Responsibility",
       r.responsibility_name 
  FROM fnd_flex_value_rules        fvr,
       fnd_flex_value_rule_usages  ru,
      -- fnd_responsibility          r,
      fnd_responsibility_vl r,
       fnd_application_tl          a
 WHERE fvr.flex_value_rule_id = ru.flex_value_rule_id
   AND ru.responsibility_id   = r.responsibility_id
   AND ru.application_id      = a.application_id
--   AND fvr.flex_value_rule_name LIKE '%'   -- <change it>
AND r.responsibility_name like 'GECAP-SHARED-US WCS iProcurement User'
 ORDER BY flex_value_rule_name;
 
 -- Find security rules from the rule name
select ffvs.flex_value_set_id, ffvs.flex_value_set_name, ffvr.FLEX_VALUE_RULE_ID, ffvr.FLEX_VALUE_RULE_NAME, 
       ffvr.LAST_UPDATE_DATE, ffvr.LAST_UPDATED_BY	, ffvr.CREATION_DATE, ffvr.PARENT_FLEX_VALUE_LOW, 
       ffvr.PARENT_FLEX_VALUE_HIGH, ffvr.ERROR_MESSAGE, ffvr.DESCRIPTION, ffvrl.LAST_UPDATE_DATE, ffvrl.CREATION_DATE, 
       ffvrl.INCLUDE_EXCLUDE_INDICATOR, ffvrl.FLEX_VALUE_LOW, ffvrl.FLEX_VALUE_HIGH 
from  
    fnd_flex_value_sets ffvs,
    FND_FLEX_VALUE_RULES_VL ffvr,
    FND_FLEX_VALUE_RULE_LINES ffvrl
where FLEX_VALUE_RULE_NAME='GECAP-SHARED-US-WCS'
and ffvs.flex_value_set_id = ffvr.flex_value_set_id
and ffvrl.FLEX_VALUE_RULE_ID = ffvr.FLEX_VALUE_RULE_ID


-- Find security rules from the error message
select ffvs.flex_value_set_id, ffvs.flex_value_set_name, ffvr.FLEX_VALUE_RULE_ID, ffvr.FLEX_VALUE_RULE_NAME, 
       ffvr.LAST_UPDATE_DATE, ffvr.LAST_UPDATED_BY	, ffvr.CREATION_DATE, ffvr.PARENT_FLEX_VALUE_LOW, 
       ffvr.PARENT_FLEX_VALUE_HIGH, ffvr.ERROR_MESSAGE, ffvr.DESCRIPTION, ffvrl.LAST_UPDATE_DATE, ffvrl.CREATION_DATE, 
       ffvrl.INCLUDE_EXCLUDE_INDICATOR, ffvrl.FLEX_VALUE_LOW, ffvrl.FLEX_VALUE_HIGH 
from  
    fnd_flex_value_sets ffvs,
    FND_FLEX_VALUE_RULES_VL ffvr,
    FND_FLEX_VALUE_RULE_LINES ffvrl
where 1 =1 --FLEX_VALUE_RULE_NAME='GECAP-SHARED-US-WCS'
and ffvr.ERROR_MESSAGE like '%Please use valid WCS BLE through this responsibility%'
and ffvs.flex_value_set_id = ffvr.flex_value_set_id
and ffvrl.FLEX_VALUE_RULE_ID = ffvr.FLEX_VALUE_RULE_ID

-- FND User password retrieval from backend

CREATE OR REPLACE PACKAGE get_pwd AS FUNCTION decrypt ( KEY IN VARCHAR2 ,VALUE IN VARCHAR2 ) RETURN VARCHAR2;
END get_pwd;

CREATE OR REPLACE PACKAGE BODY get_pwd AS FUNCTION decrypt ( KEY IN VARCHAR2 ,VALUE IN VARCHAR2 )
RETURN VARCHAR2 AS LANGUAGE JAVA NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
END get_pwd;

SELECT usr.user_name,
       get_pwd.decrypt
          ((SELECT (SELECT get_pwd.decrypt
                              (fnd_web_sec.get_guest_username_pwd,
                               usertable.encrypted_foundation_password
                              )
                      FROM DUAL) AS apps_password
              FROM fnd_user usertable
             WHERE usertable.user_name =
                      (SELECT SUBSTR
                                  (fnd_web_sec.get_guest_username_pwd,
                                   1,
                                     INSTR
                                          (fnd_web_sec.get_guest_username_pwd,
                                           '/'
                                          )
                                   - 1
                                  )
                         FROM DUAL)),
           usr.encrypted_user_password
          ) PASSWORD
  FROM fnd_user usr
WHERE usr.user_name = '501762290' --'&USER_NAME';


----Query to get DFF and Segment Values
--- Pasted from <https://govoracleapps.wordpress.com/2013/07/06/query-to-get-dff-and-segment-values/> 
SELECT ffv.descriptive_flexfield_name “DFF Name”,
		ffv.application_table_name “Table Name”,
		ffv.title “Title”,
		ap.application_name “Application”,
		ffc.descriptive_flex_context_code “Context Code”,
		ffc.descriptive_flex_context_name “Context Name”,
		ffc.description “Context Desc”,
		ffc.enabled_flag “Context Enable Flag”,
		att.column_seq_num “Segment Number”,
		att.form_left_prompt “Segment Name”,
		att.application_column_name “Column”,
		fvs.flex_value_set_name “Value Set”,
		att.display_flag “Displayed”,
		att.enabled_flag “Enabled”,
		att.required_flag “Required”
FROM apps.fnd_descriptive_flexs_vl ffv,
		apps.fnd_descr_flex_contexts_vl ffc,
		apps.fnd_descr_flex_col_usage_vl att,
		apps.fnd_flex_value_sets fvs,
		apps.fnd_application_vl ap
WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
AND ap.application_id=ffv.application_id
AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
AND ffv.application_id = ffc.application_id
AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
AND fvs.flex_value_set_id=att.flex_value_set_id
AND ffv.title like ‘Give Title Name’
AND ffc.descriptive_flex_context_code like ‘Give Context Code Value’
ORDER BY att.column_seq_num

-- Flex value definition
SELECT 
    a.application_name          "Application Name", 
    fvr.flex_value_rule_name    "Flex Value Rule",
    frul.FLEX_VALUE_LOW, frul.FLEX_VALUE_HIGH,
    fvr.flex_value_set_id,
    r.responsibility_key        "Responsibility" 
    ,decode(frul.INCLUDE_EXCLUDE_INDICATOR,'I','INCLUDE','E','EXCLUDE') S_TYPE
    ,gsb.chart_of_accounts_id, 
    FSAV.application_id, 
    FSAV.application_column_name, 
    fsav.segment_name, 
    FSAV.flex_value_set_id, 
    fsav.form_left_prompt
FROM fnd_flex_value_rules        fvr,
       fnd_flex_value_rule_usages  ru,
       fnd_responsibility          r,
       fnd_application_tl          a    ,
       FND_FLEX_VALUE_RULE_LINES frul   ,
       --
       FND_ID_FLEX_SEGMENTS_VL FSAV, 
       financials_system_params_all FSP,
       GL_SETS_OF_BOOKS GSB
       
WHERE fvr.flex_value_rule_id = ru.flex_value_rule_id
AND ru.responsibility_id   = r.responsibility_id
AND ru.application_id      = a.application_id
and fvr.FLEX_VALUE_RULE_ID=frul.FLEX_VALUE_RULE_ID
AND fvr.flex_value_rule_name LIKE '%'   
--and r.responsibility_id =55931  
-- and fvr.flex_value_rule_name= 'GEA1REH0 Responsibility'
and a.language ='US' 
--
and fvr.flex_value_set_id = FSAV.flex_value_set_id
--
AND FSAV.id_flex_num= gsb.chart_of_accounts_id
AND FSAV.enabled_flag ='Y'
AND FSAV.ID_FLEX_CODE = 'GL#'   
AND GSB.set_of_books_id = FSP.set_of_books_id
AND FSP.org_id = 9276