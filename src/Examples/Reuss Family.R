reussfamily <- data.frame ("name" = c("Kevin", "Jennifer", "Oliver", "Elliott", "Wrigley"), "age" = c(38, 36, 4, 2, 6), "role" = c("dad","mom","son","son","dog"))

reussfamily.lm <-lm (formula = age ~ role, data = reussfamily)

summary (reussfamily.lm)

reussfamily[3,2]
reussfamily[reussfamily$name=="Oliver",3]
