
--tags : chart of accounts, coa, dff segments, ledger, security rules 

------------------------------------------------------
------   Chart OF Accounts Queries 
------------------------------------------------------

select * from financials_system_params_all
where org_id = 9191

select * from gl_sets_of_books 
where SET_OF_BOOKS_ID = 2970
--SET_OF_BOOKS_ID	NAME	SHORT_NAME	CHART_OF_ACCOUNTS_ID
--2970	GEL-EMEA_PL_GESSS	GEL-EMEA_PL2970(USD)	52089

select * from org_organization_definitions
where chart_of_accounts_id = 52089
--ORGANIZATION_ID	BUSINESS_GROUP_ID	ORGANIZATION_CODE	ORGANIZATION_NAME	SET_OF_BOOKS_ID	CHART_OF_ACCOUNTS_ID	OPERATING_UNIT	LEGAL_ENTITY
--9191	0	GEL	GEL-EMEA	2970	52089	9191	84300

select chart_of_accounts_id
from financials_system_params_all FSP
     , GL_SETS_OF_BOOKS GSB
where GSB.set_of_books_id = FSP.set_of_books_id
AND   FSP.org_id = 468

-- COA id, segment number, seg type, 
SELECT gsb.chart_of_accounts_id, FSAV.application_id, FSAV.application_column_name, fsav.segment_name, FSAV.flex_value_set_id, fsav.form_left_prompt
FROM FND_ID_FLEX_SEGMENTS_VL FSAV, 
     financials_system_params_all FSP,
     GL_SETS_OF_BOOKS GSB
WHERE FSAV.id_flex_num= gsb.chart_of_accounts_id
--AND FSAV.segment_attribute_type in ('GL_BALANCING', 'GL_ACCOUNT', 'FA_COST_CTR')
AND FSAV.enabled_flag ='Y'
AND FSAV.ID_FLEX_CODE = 'GL#'   
AND GSB.set_of_books_id = FSP.set_of_books_id
AND FSP.org_id = 9276


-- R12 Leger and COA structure
SELECT DISTINCT sob.name Ledger_Name
	, sob.ledger_id Ledger_Id
	, sob.chart_of_accounts_id coa_id
	, fifst.id_flex_structure_name struct_name
	, ifs.segment_name
	, ifs.application_column_name column_name
	, sav1.attribute_value BALANCING
	, sav2.attribute_value COST_CENTER
	, sav3.attribute_value NATURAL_ACCOUNT
	, sav4.attribute_value INTERCOMPANY
	, sav5.attribute_value SECONDARY_TRACKING
	, sav6.attribute_value GLOBAL
	, ffvs.flex_value_set_name
	, ffvs.flex_value_set_id
FROM fnd_id_flex_structures fifs
	, fnd_id_flex_structures_tl fifst
	, fnd_segment_attribute_values sav1
	, fnd_segment_attribute_values sav2
	, fnd_segment_attribute_values sav3
	, fnd_segment_attribute_values sav4
	, fnd_segment_attribute_values sav5
	, fnd_segment_attribute_values sav6
	, fnd_id_flex_segments ifs
	, fnd_flex_value_sets ffvs
	, gl_ledgers sob
WHERE 1=1
AND fifs.id_flex_code = ‘GL#’
AND fifs.application_id = fifst.application_id
AND fifs.id_flex_code = fifst.id_flex_code
AND fifs.id_flex_num = fifst.id_flex_num
AND fifs.application_id = ifs.application_id
AND fifs.id_flex_code = ifs.id_flex_code
AND fifs.id_flex_num = ifs.id_flex_num
AND sav1.application_id = ifs.application_id
AND sav1.id_flex_code = ifs.id_flex_code
AND sav1.id_flex_num = ifs.id_flex_num
AND sav1.application_column_name = ifs.application_column_name
AND sav2.application_id = ifs.application_id
AND sav2.id_flex_code = ifs.id_flex_code
AND sav2.id_flex_num = ifs.id_flex_num
AND sav2.application_column_name = ifs.application_column_name
AND sav3.application_id = ifs.application_id
AND sav3.id_flex_code = ifs.id_flex_code
AND sav3.id_flex_num = ifs.id_flex_num
AND sav3.application_column_name = ifs.application_column_name
AND sav4.application_id = ifs.application_id
AND sav4.id_flex_code = ifs.id_flex_code
AND sav4.id_flex_num = ifs.id_flex_num
AND sav4.application_column_name = ifs.application_column_name
AND sav5.application_id = ifs.application_id
AND sav5.id_flex_code = ifs.id_flex_code
AND sav5.id_flex_num = ifs.id_flex_num
AND sav5.application_column_name = ifs.application_column_name
AND sav6.application_id = ifs.application_id
AND sav6.id_flex_code = ifs.id_flex_code
AND sav6.id_flex_num = ifs.id_flex_num
AND sav6.application_column_name = ifs.application_column_name
AND sav1.segment_attribute_type = ‘GL_BALANCING’
AND sav2.segment_attribute_type = ‘FA_COST_CTR’
AND sav3.segment_attribute_type = ‘GL_ACCOUNT’
AND sav4.segment_attribute_type = ‘GL_INTERCOMPANY’
AND sav5.segment_attribute_type = ‘GL_SECONDARY_TRACKING’
AND sav6.segment_attribute_type = ‘GL_GLOBAL’
AND ifs.id_flex_num = sob.chart_of_accounts_id
AND ifs.flex_value_set_id = ffvs.flex_value_set_id
AND sob.ledger_id =’Give Ledger ID or Set_Of_Books_Id’
ORDER BY sob.name, sob.chart_of_accounts_id, ifs.application_column_name;


-- Security rules defined for an OU
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
       --        
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
-- sample respons id given below... 
and r.responsibility_id =55931 



-- Check value set values for a COA segment
SELECT ffvs.flex_value_set_id ,
		ffvs.flex_value_set_name ,
		ffvs.description set_description ,
		ffvs.validation_type,
		ffv.flex_value,ffvt.description 
FROM fnd_flex_value_sets ffvs ,
      fnd_flex_values ffv ,
      fnd_flex_values_tl ffvt
WHERE
ffvs.flex_value_set_id = ffv.flex_value_set_id
and ffv.flex_value_id = ffvt.flex_value_id
AND ffvt.language = USERENV('LANG')
--and flex_value_set_name like 'GECAP-SHARED-US_BLE'
and ffvs.flex_value_set_id = 1017392
and ffv.flex_value in (select distinct GCC.segment1
                  FROM   apps.gl_code_combinations    GCC
                  ,apps.po_requisition_lines_all    PRL
                  ,apps.po_req_distributions_all    PRD
                  ,APPS.po_requisition_headers_all prha
                  WHERE  1=1 --
                  AND    prd.requisition_line_id   = prl.requisition_line_id
                  AND    gcc.code_combination_id   = prd.code_combination_id
                  AND    prha.requisition_header_id = prl.requisition_header_id
                  AND prha.org_id = 9723)
ORDER BY flex_value asc

