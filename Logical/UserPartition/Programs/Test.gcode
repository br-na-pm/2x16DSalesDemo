DEFINE MoveAbsB AS G90 G101 G126
DEFINE MoveRelB AS G91 G101 G126

G71 (Set the units to mm)

def REAL feedRate = 100 * 60
(MoveAbsB X=0 Y=0 Z=0 F=feedRate
MoveAbsB X=500 Y=60 Z=155 F=feedRate