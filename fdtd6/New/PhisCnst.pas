unit PhisCnst;

{Модуль, содержащий основные физические константы}

{$D-}

interface

const
  Eps0 = 8.85e-12;
  Mu0 = 4 * Pi * 1e-7;
  C = 3e8;
  Z0 = 377;

  EpsDivMu = Eps0 / Mu0;
  MuDivEps = Mu0 / Eps0;

  Ez0 = 100;
  Hz0 = Ez0 / Z0;


implementation

end.
