/* Automation Studio generated header file */
/* Do not edit ! */
/* SlFreeBase 2.01.0 */

#ifndef _SLFREEBASE_
#define _SLFREEBASE_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _SlFreeBase_VERSION
#define _SlFreeBase_VERSION 2.01.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "brsystem.h"
		#include "sys_lib.h"
#endif
#ifdef _SG4
		#include "brsystem.h"
		#include "sys_lib.h"
#endif
#ifdef _SGC
		#include "brsystem.h"
		#include "sys_lib.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define _sfbNUM_IMP_ZVD_DTm1 4U
 #define _sfbNUM_IMP_ZVDm1 2U
 #define _sfbNUM_IMP_ZVD_DT 5U
 #define _sfbNUM_IMP_ZVD 3U
 #define sfbERR_INVALID_PARAMETER (-1)
 #define sfbERR_UNABLE_TO_ALLOCATE_BUFFER (-2)
 #define sfbERR_UNABLE_TO_FREE_BUFFER (-3)
#else
 _GLOBAL_CONST unsigned char _sfbNUM_IMP_ZVD_DTm1;
 _GLOBAL_CONST unsigned char _sfbNUM_IMP_ZVDm1;
 _GLOBAL_CONST unsigned char _sfbNUM_IMP_ZVD_DT;
 _GLOBAL_CONST unsigned char _sfbNUM_IMP_ZVD;
 _GLOBAL_CONST signed long sfbERR_INVALID_PARAMETER;
 _GLOBAL_CONST signed long sfbERR_UNABLE_TO_ALLOCATE_BUFFER;
 _GLOBAL_CONST signed long sfbERR_UNABLE_TO_FREE_BUFFER;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum SFBshaperTypeEnum
{	sfbSHAPER_OFF,
	sfbSHAPER_ZV,
	sfbSHAPER_ZVD
} SFBshaperTypeEnum;

typedef enum SFBcontShapeEnum
{	sfbRECTANGULAR,
	sfbCIRCULAR,
	_sfbSHAPEn
} SFBcontShapeEnum;

typedef struct SFBshaperDataType
{	float Frequency;
	float Damping;
	enum SFBshaperTypeEnum Type;
} SFBshaperDataType;

typedef struct SFBrecordType
{	double val;
	double a;
} SFBrecordType;

typedef struct SFBinfoType
{	float ShaperDepthTime;
} SFBinfoType;

typedef struct SFBcontAdvancedType
{	float csi;
	float LiquidMass;
	float Density;
} SFBcontAdvancedType;

typedef struct SFBmodelType
{	double m0;
	double m1;
	double l;
	double c_rot;
} SFBmodelType;

typedef struct SFBoscModeType
{	double wd;
	double D;
} SFBoscModeType;

typedef struct SFBcontShaperType
{	double A;
	double t;
} SFBcontShaperType;

typedef struct SFBdiscShaperType
{	double A;
	unsigned long n;
} SFBdiscShaperType;

typedef struct SFBshaperType
{	struct SFBoscModeType Osc_mode;
	enum SFBshaperTypeEnum Type;
	struct SFBcontShaperType CT_shaper[3];
	struct SFBdiscShaperType DT_shaper[5];
	double wn;
	double Td;
} SFBshaperType;

typedef struct _SFBshaperPrivType
{	double Ts;
	unsigned long step;
	unsigned long pMem;
	unsigned long nSlots;
	unsigned short rc;
	plcbit update_old;
	plcbit updating;
	plcbit updated;
} _SFBshaperPrivType;

typedef struct _SFBcontainerPrivType
{	plcbit Done;
	plcbit Error;
} _SFBcontainerPrivType;

typedef struct SFBshaper
{
	/* VAR_INPUT (analog) */
	double In;
	struct SFBshaperDataType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	double Out;
	struct SFBinfoType Info;
	/* VAR (analog) */
	struct _SFBshaperPrivType priv;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Update;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit UpdateDone;
	plcbit Error;
	plcbit Bypass;
} SFBshaper_typ;

typedef struct SFBcontainer
{
	/* VAR_INPUT (analog) */
	float Length;
	float FillLevel;
	enum SFBcontShapeEnum Shape;
	struct SFBcontAdvancedType Advanced;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct SFBshaperDataType Result;
	struct SFBmodelType ResultModel;
	/* VAR (analog) */
	struct _SFBcontainerPrivType priv;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit Done;
} SFBcontainer_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void SFBshaper(struct SFBshaper* inst);
_BUR_PUBLIC void SFBcontainer(struct SFBcontainer* inst);


#ifdef __cplusplus
};
#endif
#endif /* _SLFREEBASE_ */

