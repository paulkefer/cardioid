#include "Reaction.hh"
#include "Interpolation.hh"
#include "object.h"
#include "reactionFactory.hh"
#include <vector>
#include <sstream>

#include <simdops/simdops.hpp>

REACTION_FACTORY(VecTT06)(OBJECT* obj, const double dt, const int numPoints, const ThreadTeam& group);    

namespace VecTT06
{


   struct State
   {
      double Ca_SR[SIMDOPS_FLOAT64V_WIDTH];
      double Ca_i[SIMDOPS_FLOAT64V_WIDTH];
      double Ca_ss[SIMDOPS_FLOAT64V_WIDTH];
      double K_i[SIMDOPS_FLOAT64V_WIDTH];
      double Na_i[SIMDOPS_FLOAT64V_WIDTH];
      double R_prime[SIMDOPS_FLOAT64V_WIDTH];
      double Xr1[SIMDOPS_FLOAT64V_WIDTH];
      double Xr2[SIMDOPS_FLOAT64V_WIDTH];
      double Xs[SIMDOPS_FLOAT64V_WIDTH];
      double d[SIMDOPS_FLOAT64V_WIDTH];
      double f[SIMDOPS_FLOAT64V_WIDTH];
      double f2[SIMDOPS_FLOAT64V_WIDTH];
      double fCass[SIMDOPS_FLOAT64V_WIDTH];
      double h[SIMDOPS_FLOAT64V_WIDTH];
      double j[SIMDOPS_FLOAT64V_WIDTH];
      double m[SIMDOPS_FLOAT64V_WIDTH];
      double r[SIMDOPS_FLOAT64V_WIDTH];
      double s[SIMDOPS_FLOAT64V_WIDTH];
   };
   class ThisReaction : public Reaction
   {
    public:
      ThisReaction(const int numPoints, const double __dt);
      std::string methodName() const;
      
      void createInterpolants(const double _dt);
      //void updateNonGate(double dt, const VectorDouble32&Vm, VectorDouble32&dVR);
      //void updateGate   (double dt, const VectorDouble32&Vm) ;
      virtual void getCheckpointInfo(std::vector<std::string>& fieldNames,
                                     std::vector<std::string>& fieldUnits) const;
      virtual int getVarHandle(const std::string& varName) const;
      virtual void setValue(int iCell, int varHandle, double value);
      virtual double getValue(int iCell, int varHandle) const;
      virtual double getValue(int iCell, int varHandle, double V) const;
      virtual const std::string getUnit(const std::string& varName) const;

    private:
      unsigned nCells_;
      double __cachedDt;

    public:
      //PARAMETERS
      double g_CaL;
      double g_K1;
      double g_Kr;
      double g_Ks;
      double g_Na;
      double g_bca;
      double g_bna;
      double g_pCa;
      double g_pK;
      double g_to;

    public:
      void calc(double dt,
                const VectorDouble32& Vm,
                const std::vector<double>& iStim,
                VectorDouble32& dVm);
      void initializeMembraneVoltage(VectorDouble32& Vm);
    private:
      std::vector<State> state_;

      Interpolation _interpolant[30];
      FRIEND_FACTORY(VecTT06)(OBJECT* obj, const double dt, const int numPoints, const ThreadTeam& group);
   };
}

