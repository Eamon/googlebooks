SELECT  m.moduleid, 
        m.modulecode, 
        m.moduletitle, 
        mb.moduleresourcetypeid,
        mb.modulebookauthor,
        mb.modulebooktitle,
        mb.modulebookyear,
        mb.modulebookpublisher,
        mb.modulebookisbn
FROM modulebooks = mb
LEFT OUTER JOIN modules m ON m.moduleid = mb.moduleid 
LEFT OUTER JOIN deliveryperiods dp3 ON     dp3.deliveryperiodId = m.moduleEndDeliveryPeriodId
LEFT outer join deliveryperiods dp4 on     dp4.deliveryperiodId = m.moduleStartDeliveryPeriodId
WHERE (m.moduleIsDeleted = 'no' AND  m.statusid= 14) AND (m.moduleEndDeliveryPeriodId is null OR  dp3.deliveryperiodStartDate > (SELECT dp5.deliveryperiodStartDate
FROM     deliveryperiods dp5
WHERE   dp5.deliveryperiodenddate > CURRENT_DATE LIMIT 1))
order by m.modulecode ASC
