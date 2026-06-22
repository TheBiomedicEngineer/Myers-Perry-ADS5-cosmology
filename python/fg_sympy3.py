import sympy as sp
x, z, M = sp.symbols('x z M', real=True)
r = sp.symbols('r', positive=True)

def blocks(A1,A2):
    s,c=sp.sin(x),sp.cos(x); X1,X2=1-A1**2,1-A2**2
    def gbar(rr):
        g=sp.zeros(5,5)
        g[0,0]=(rr**2+1)*((A1**2-1)*s**2+(A2**2-1)*c**2)/((A1**2-1)*(A2**2-1))
        g[1,1]=rr**2*((A1**2*rr**2+A1**2+rr**4+rr**2)*s**2+(A2**2*rr**2+A2**2+rr**4+rr**2)*c**2)/((A1**2*rr**2+A1**2+rr**4+rr**2)*(A2**2*rr**2+A2**2+rr**4+rr**2))
        g[2,2]=(-A1**2*s**2+A2**2*s**2-A2**2-rr**2)/(A1**2*s**2-A2**2*s**2+A2**2-1)
        g[3,3]=(-A1**2-rr**2)*c**2/(A1**2-1)
        g[4,4]=(-A2**2-rr**2)*s**2/(A2**2-1)
        return g
    def kv(rr): return sp.Matrix([c**2/X1+s**2/X2, rr**2/(1+rr**2)*(c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2)),0,-A1*c**2/X1,-A2*s**2/X2])
    def U(rr): return (c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2))*(rr**2+A1**2)*(rr**2+A2**2)
    def gf(rr,MM):
        k=kv(rr); return gbar(rr)+(2*MM/U(rr))*(k*k.T)
    return gf

def run(A1,A2,D):
    gf=blocks(A1,A2)
    grr=gf(r,M)[1,1]
    nz=7
    # r(z)=1/z+sum b_k z^{2k-1}, risolvo iterativo
    bs=[sp.Symbol('b%d'%k) for k in range(nz)]
    rser=1/z+sum(bs[k]*z**(2*k+1) for k in range(nz))
    e=sp.expand(z**2*((sp.diff(rser,z))**2*grr.subs(r,rser)-1/z**2))
    e=sp.series(e,z,0,2*nz).removeO()
    subs={}
    for k in range(nz):
        coef=sp.expand(e.coeff(z,2*k+1)).subs(subs) if False else None
    # iterativo sui coeff pari/dispari: risolvo ordine per ordine
    for power in range(0,2*nz):
        c=sp.expand(e.coeff(z,power)).subs(subs)
        if c==0: continue
        unk=[b for b in bs if b in c.free_symbols]
        if not unk: continue
        s_=sp.solve(c,unk[0])
        if s_: subs[unk[0]]=sp.simplify(s_[0])
    rz=rser.subs(subs)
    idx=[0,2,3,4]
    g0=sp.zeros(4,4);g2=sp.zeros(4,4);g4=sp.zeros(4,4)
    GF=gf(r,M)
    for i in range(4):
        for j in range(4):
            comp=sp.series((z**2*GF[idx[i],idx[j]]).subs(r,rz),z,0,6).removeO()
            comp=sp.expand(comp)
            g0[i,j]=comp.coeff(z,0);g2[i,j]=comp.coeff(z,2);g4[i,j]=comp.coeff(z,4)
    g4M=sp.Matrix(4,4,lambda i,j: sp.diff(g4[i,j],M))
    g0inv=g0.inv()
    trace=sp.simplify(sum(g0inv[a,b]*g4M[a,b] for a in range(4) for b in range(4)))
    mix=g0inv*g4M
    tt=mix[0,0]
    # quad/mono via campionamento (no integrate): valuto a piu' x e fitto a+bcos2x+ccos4x+dcos6x
    import numpy as np
    xs=[0.3,0.7,1.0,1.3,1.5,0.5,0.9]
    A=[];y=[]
    for xv in xs:
        A.append([1,sp.cos(2*xv),sp.cos(4*xv),sp.cos(6*xv)])
        y.append(float(tt.subs(x,xv)))
    A=np.array(A,float);y=np.array(y,float)
    coef=np.linalg.lstsq(A,y,rcond=None)[0]
    mono,quad=coef[0],coef[1]
    return sp.simplify(g4M[0,0]),trace,coef,quad/mono,quad/mono/float(D)

for (A1,A2,lab,D) in [(sp.Rational(1,2),sp.Rational(1,5),"{1/2,1/5}",sp.Rational(1,4)-sp.Rational(1,25)),
                      (sp.Rational(1,3),sp.Rational(1,5),"{1/3,1/5}",sp.Rational(1,9)-sp.Rational(1,25))]:
    g4Mtt,trace,coef,qm,qmD=run(A1,A2,D)
    print("====",lab,"====")
    print("g4M_tt =",g4Mtt)
    print("C1 traccia =",trace)
    print("T^t_t fourier [mono,cos2,cos4,cos6] =",[round(c,5) for c in coef])
    print("quad/mono =",round(qm,5)," (quad/mono)/D =",round(qmD,5))
