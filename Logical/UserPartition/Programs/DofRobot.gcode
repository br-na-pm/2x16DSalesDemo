def plc_global path_synch IndvDanceDemoIfTyp gDofDemoIf

DEFINE MoveAbsB AS G90 G101 G126
DEFINE MoveRelB AS G91 G101 G126

G71 (Set the units to mm)
def REAL parFeedRate = gDofDemoIf.Par.RobotVelocity * 60
def REAL pickXDistance = 20
F= parFeedRate
N100 MoveAbsB 0 X=480 Y=40 Z=155  (Center position)
N10 $WHILE gDofDemoIf.Cmd.Run
    N101 MoveAbsB 50 X=300 Y=40 Z=100 (pick center line)
    G91
    N102 MoveRelB 50 X=0 Y=80
    N103 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N104 G101 X=pickXDistance
    N105 MoveRelB 25 Z=50 X=-pickXDistance*2
    N106 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N107 MoveRelB 50 X=0 Y=-80 Z=-10
    N108 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N109 G101 X=pickXDistance
    N110 MoveRelB 25 Z=50 X=-pickXDistance*2

    N111 MoveRelB 50 X=60 Y=80 Z=10
    N112 MoveRelB 50 X=60 Y=80 Z=-10
    N113 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N114 G101 X=pickXDistance
    N115 MoveRelB 25 Z=50 X=-pickXDistance*2
    N116 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N117 MoveRelB 50 X=0 Y=-80 Z=-10
    N118 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N119 G101 X=pickXDistance
    N120 MoveRelB 25 Z=50 X=-pickXDistance*2

    N121 MoveRelB 50 X=60 Y=80 Z=10
    N122 MoveRelB 50 X=60 Y=80 Z=-10
    N123 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N124 G101 X=pickXDistance
    N125 MoveRelB 25 Z=50 X=-pickXDistance*2
    N126 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N127 MoveRelB 50 X=0 Y=-80 Z=-10
    N128 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N129 G101 X=pickXDistance
    N130 MoveRelB 25 Z=50 X=-pickXDistance*2

    N131 MoveRelB 50 X=60 Y=80 Z=10
    N132 MoveRelB 50 X=60 Y=80 Z=-10
    N133 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N134 G101 X=pickXDistance
    N135 MoveRelB 25 Z=50 X=-pickXDistance*2
    N136 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N137 MoveRelB 50 X=0 Y=-80 Z=-10
    N138 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N139 G101 X=pickXDistance
    N140 MoveRelB 25 Z=50 X=-pickXDistance*2

    N141 MoveRelB 50 X=-60 Y=80 Z=10
    N142 MoveRelB 50 X=-60 Y=80 Z=-10
    N143 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N144 G101 X=pickXDistance
    N145 MoveRelB 25 Z=50 X=-pickXDistance*2
    N146 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N147 MoveRelB 50 X=0 Y=-80 Z=-10
    N148 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N149 G101 X=pickXDistance
    N150 MoveRelB 25 Z=50 X=-pickXDistance*2

    N151 MoveRelB 50 X=-60 Y=80 Z=10
    N152 MoveRelB 50 X=-60 Y=80 Z=-10
    N153 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N154 G101 X=pickXDistance
    N155 MoveRelB 25 Z=50 X=-pickXDistance*2
    N156 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N157 MoveRelB 50 X=0 Y=-80 Z=-10
    N158 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N159 G101 X=pickXDistance
    N160 MoveRelB 25 Z=50 X=-pickXDistance*2

    N161 MoveRelB 50 X=-60 Y=80 Z=10
    N162 MoveRelB 50 X=-60 Y=80 Z=-10
    N163 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N164 G101 X=pickXDistance
    N165 MoveRelB 25 Z=50 X=-pickXDistance*2
    N166 MoveRelB 50 X=0 Y=-80 Z=10 (Move back to center line)
    N167 MoveRelB 50 X=0 Y=-80 Z=-10
    N168 MoveRelB 25 Z=-50 X=pickXDistance (Pick)
    N169 G101 X=pickXDistance
    N170 MoveRelB 25 Z=50 X=-pickXDistance*2
    G172
$ENDWHILE

N999 MoveAbsB 0 X=480 Y=60 Z=155 