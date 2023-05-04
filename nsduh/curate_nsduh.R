load('~/Box Sync/teaching/PMB/datasets/nsduh/NSDUH_2016.RData')
# changing name of data set to something shorter
puf = PUF2016_022818
rm(PUF2016_022818)
# demographics
puf$age = factor(puf$CATAG3, labels=c('12-17', '18-25', '26-34', '35-49', '50 or older'))
puf$nERvisit = ifelse(puf$NMERTMT2 %in% c(985, 994, 997, 998), NA, puf$NMERTMT2)
puf$ERvisit = ifelse(puf$nERvisit>0, 1, 0)
demo = c('age', 'nERvisit', 'ERvisit')
# ever used variables
binomvars = c(grep('flag', names(puf), value=TRUE))
# used in the past month
mo = grep('mon$', names(puf), value=TRUE)
# age of first use variables
agevars = grep('ir.*age', names(puf), value=TRUE)
# number of days of use in the past 30 days
movars = grep('^[Ii][Rr].*(fm|30N)', names(puf), value=TRUE)
puf = puf[,c(demo, binomvars, mo, agevars, movars, 'psilcy', 'addprev')]
puf$psilcy = ifelse(puf$psilcy==1, 'yes', 'no')
puf$addprev = ifelse(puf$addprev==1, 'yes', ifelse(puf$addprev==2, 'no', NA) )
puf[, c(binomvars, mo)] = lapply(puf[, c(binomvars, mo)], function(x) factor(ifelse(x==0, 'no', 'yes')))
puf[, movars] = lapply(puf[,movars], function(x) ifelse(x %in% c(91, 93), 0, x) )
puf[, agevars] = lapply(puf[,agevars], function(x) ifelse(x %in% c(991, 993, 999), NA, x) )

saveRDS(puf, '~/Box Sync/teaching/PMB/datasets/nsduh/puf.rds')
write.csv(puf, '~/Box Sync/teaching/PMB/datasets/nsduh/puf.csv', row.names=FALSE)
