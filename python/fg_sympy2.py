import sympy as sp
x, z, M = sp.symbols('x z M', real=True)
r = sp.symbols('r', positive=True)

def gbar(rr, cc, A1, A2):
    s, c = sp.sin(cc), sp.cos(cc)
    g = sp.zeros(5,5)
    g[0,0]=(rr**2+1)*((A1**2-1)*s**2+(A2**2-1)*c**2)/((A1**2-1)*(A2**2-1))
    g[1,1]=rr**2*((A1**2*rr**2+A1**2+rr**4+rr**2)*s**2+(A2**2*rr**2+A2**2+rr**4+rr**2)*c**2)/((A1**2*rr**2+A1**2+rr**4+rr**2)*(A2**2*rr**2+A2**2+rr**4+rr**2))
    g[2,2]=(-A1**2*s**2+A2**2*s**2-A2**2-rr**2)/(A1**2*s**2-A2**2*s**2+A2**2-1)
    g[3,3]=(-A1**2-rr**2)*c**2/(A1**2-1)
    g[4,4]=(-A2**2-rr**2)*s**2/(A2**2-1)
    return g

def kvec(rr, cc, A1, A2):
    s, c = sp.sin(cc), sp.cos(cc); X1, X2 = 1-A1**2, 1-A2**2
    return sp.Matrix([c**2/X1+s**2/X2, rr**2/(1+rr**2)*(c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2)),
        0, -A1*c**2/X1, -A2*s**2/X2])

def Ufun(rr, cc, A1, A2):
    s, c = sp.sin(cc), sp.cos(cc)
    return (c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2))*(rr**2+A1**2)*(rr**2+A2**2)

def gfull(rr, cc, A1, A2, MM):
    k = kvec(rr,cc,A1,A2)
    return gbar(rr,cc,A1,A2) + (2*MM/Ufun(rr,cc,A1,A2))*(k*k.T)

def run(A1, A2, D):
    grr = sp.simplify(gfull(r, x, A1, A2, M)[1,1])
    # costruisco r(z) iterativamente: r = 1/z + b1 z + b3 z^3 + ...
    nz=8
    bs=sp.symbols('b1:%d'%(nz+1))
    rser=1/z+sum(bs[k]*z**(2*k+1) for k in range(nz))
    # eq = (dr/dz)^2 grr - 1/z^2 ; moltiplico per z^2 per togliere i poli
    e=sp.together((sp.diff(rser,z))**2*grr.subs(r,rser)-1/z**2)
    e=sp.expand(z**2*e)               # ora serie di Taylor in z
    ser=sp.series(e,z,0,2*nz).removeO()
    ser=sp.expand(ser)
    eqs=[sp.simplify(ser.coeff(z,j)) for j in range(0,2*nz)]
    eqs=[q for q in eqs if q!=0]
    sol=sp.solve(eqs[:nz], list(bs), dict=True)[0]
    rz=rser.subs(sol)
    idx=[0,2,3,4]
    g0=sp.zeros(4,4); g2=sp.zeros(4,4); g4=sp.zeros(4,4)
    gf=gfull(r,x,A1,A2,M)
    for i in range(4):
        for j in range(4):
            f=(z**2*gf[idx[i],idx[j]]).subs(r,rz)
            comp=sp.series(f,z,0,6).removeO()
            comp=sp.expand(comp)
            g0[i,j]=comp.coeff(z,0); g2[i,j]=comp.coeff(z,2); g4[i,j]=comp.coeff(z,4)
    g4M=sp.Matrix(4,4,lambda i,j: sp.diff(g4[i,j],M))
    g0inv=g0.inv()
    mix=sp.simplify(g0inv*g4M)
    trace=sp.simplify(sum(g0inv[a,b]*g4M[a,b] for a in range(4) for b in range(4)))
    tt=sp.expand_trig(sp.simplify(mix[0,0]))
    tt=sp.simplify(sp.expand(tt.rewrite(sp.cos)))
    # riduco a forma cos(n x)
    tt2=sp.simplify(sp.fu(tt))
    mono=sp.simplify(sp.integrate(tt2,(x,0,sp.pi))/sp.pi)
    quad=sp.simplify(2*sp.integrate(tt2*sp.cos(2*x),(x,0,sp.pi))/sp.pi)
    return sp.simplify(g4M[0,0]), trace, tt2, sp.N(quad/mono), sp.N(quad/mono/D)

for (A1,A2,lab,D) in [(sp.Rational(1,2),sp.Rational(1,5),"{1/2,1/5}",sp.Rational(1,4)-sp.Rational(1,25)),
                      (sp.Rational(1,3),sp.Rational(1,5),"{1/3,1/5}",sp.Rational(1,9)-sp.Rational(1,25))]:
    g4Mtt,trace,tt,qm,qmD=run(A1,A2,D)
    print("====",lab,"====")
    print("g4M_tt =",g4Mtt)
    print("C1 traccia =",trace)
    print("T^t_t|_M =",tt)
    print("quad/mono =",qm,"  (quad/mono)/D =",qmD)
