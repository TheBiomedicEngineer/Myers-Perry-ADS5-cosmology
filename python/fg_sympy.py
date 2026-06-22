import sympy as sp

x, z, M = sp.symbols('x z M', real=True)

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
    return sp.Matrix([c**2/X1+s**2/X2,
        rr**2/(1+rr**2)*(c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2)),
        0, -A1*c**2/X1, -A2*s**2/X2])

def Ufun(rr, cc, A1, A2):
    s, c = sp.sin(cc), sp.cos(cc)
    return (c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2))*(rr**2+A1**2)*(rr**2+A2**2)

def gfull(rr, cc, A1, A2, MM):
    k = kvec(rr,cc,A1,A2)
    return gbar(rr,cc,A1,A2) + (2*MM/Ufun(rr,cc,A1,A2))*(k*k.T)

def run(A1, A2, label):
    r = sp.symbols('r', positive=True)
    grr = gfull(r, x, A1, A2, M)[1,1]
    # r(z): dr/dz)^2 * grr = 1/z^2 ; serie r = 1/z + sum b_k z^(2k-1)
    nz=8
    b=sp.symbols('b1:%d'%(nz+1))
    rser=1/z+sum(b[k]*z**(2*k+1) for k in range(nz))
    expr=sp.series((sp.diff(rser,z))**2*grr.subs(r,rser)-1/z**2,z,0,2*nz-1).removeO()
    expr=sp.expand(expr)
    poly=sp.Poly(expr,z)
    eqs=[poly.coeff_monomial(z**j) for j in range(-2,2*nz-2) if poly.coeff_monomial(z**j)!=0]
    # include negative powers: handle via as_coefficients_dict
    cd=expr.as_coefficients_dict()
    eqs=[]
    for k in range(nz):
        # match each unknown by ascending order using coefficients
        pass
    sol=sp.solve([cd.get(z**j,0) for j in range(-1,2*nz-2)], list(b), dict=True)
    sol=sol[0]
    rz=rser.subs(sol)
    idx=[0,2,3,4]
    g0=sp.zeros(4,4); g2=sp.zeros(4,4); g4=sp.zeros(4,4)
    gf=gfull(r,x,A1,A2,M)
    for i in range(4):
        for j in range(4):
            comp=sp.series((z**2*gf[idx[i],idx[j]]).subs(r,rz),z,0,6).removeO()
            comp=sp.expand(comp)
            g0[i,j]=comp.coeff(z,0); g2[i,j]=comp.coeff(z,2); g4[i,j]=comp.coeff(z,4)
    g4M=sp.simplify(sp.Matrix(4,4,lambda i,j: sp.diff(g4[i,j],M)))
    g0inv=sp.simplify(g0.inv())
    mix=sp.simplify(g0inv*g4M)
    return g0,g2,g4,g4M,mix

for (A1,A2,lab,D) in [(sp.Rational(1,2),sp.Rational(1,5),"{1/2,1/5}",sp.Rational(1,4)-sp.Rational(1,25)),
                      (sp.Rational(1,3),sp.Rational(1,5),"{1/3,1/5}",sp.Rational(1,9)-sp.Rational(1,25))]:
    g0,g2,g4,g4M,mix=run(A1,A2,lab)
    print("====",lab,"====")
    print("g4M_tt =", sp.simplify(g4M[0,0]))
    # traccia g4M
    trace=sp.simplify(sum(g0.inv()[a,b]*g4M[a,b] for a in range(4) for b in range(4)))
    print("C1 traccia g4M =", trace)
    tt=sp.expand_trig(sp.simplify(mix[0,0]))
    print("T^t_t|_M =", tt)
    # quad/mono
    mono=tt.subs({sp.cos(2*x):0,sp.cos(4*x):0,sp.cos(6*x):0})
    quad=tt.coeff(sp.cos(2*x))
    print("quad/mono =", sp.N(quad/mono), " /D =", sp.N(quad/mono/D))
