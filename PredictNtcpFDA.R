library(fda.usc)

# Select toxicity: dysphagia, mucositis
toxicityName <- 'mucositis'
# Select which model to use: PLR, FPCLR, FPLSLR
dimensionalityReduction <- 'FPLSLR'

# Select OAR to use based on toxicity
if (toxicityName == 'mucositis') {
    oar <- 'OM' # oral mucosa
} elif (toxicityName == 'dyshagia') {
    oar <- 'PM' # pharyngeal mucosa
}

# Import clinical data
clinicalData <- read.csv('clinicalData.csv', head = TRUE)

# Import DVH data
dvhData <- read.csv(paste(oar, 'dvh.csv', sep = ''), head = FALSE)
patientIDs.intersect = intersect(dvhData[, 1], clinicalData[, 1])
dvh = fdata(subset(dvhData, V1 %in% patientIDs.intersect, select = -1))
# Plot DVH data
plot(dvh)

newldata = list('df' = clinicalData, 'dvh' = dvh)
load(paste(toxicityName, dimensionalityReduction, '.rda', sep = ''))
predictedNtcp <-predict.fregre.glm(model.final, newldata)
print(patientIDs.intersect)
print(round(predictedNtcp, digits = 2))
