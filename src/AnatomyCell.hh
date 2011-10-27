#ifndef ANATOMY_CELL_HH
#define ANATOMY_CELL_HH

#include "Long64.hh"

class AnatomyCell
{
  public:
   Long64 gid_;
   int cellType_;
   int theta_;
   int phi_;
   int dest_;
   int sortind_;
   static bool destLessThan(const AnatomyCell &a, const AnatomyCell &b)
        { return a.dest_ < b.dest_; }
   static bool indLessThan(const AnatomyCell &a, const AnatomyCell &b)
        { return a.sortind_ < b.sortind_; }
};

#endif
