import sympy as sp, numpy as np
z, M = sp.symbols('z M', real=True)
r = sp.symbols('r', positive=True)

def run(A1f,A2f,D):
    A1,A2=sp.Rational(A1f),sp.Rational(A2f)
    xnum=sp.Symbol('xn',real=True)  # x tenuto simbolico finche' serve, poi numerico
    results=[]
    # Per ogni valore di x numerico, faccio tutto il FG numericamente in z.
    def Tttmix_at(xv):
        xx=sp.nsimplify(xv) if False else xv
        s,c=np.sin(xv),np.cos(xv); X1,X2=float(1-A1**2),float(1-A2**2)
        a1,a2=float(A1),float(A2)
        def gbar(rr):
            g=np.zeros((5,5))
            g[0,0]=(rr**2+1)*((a1**2-1)*s**2+(a2**2-1)*c**2)/((a1**2-1)*(a2**2-1))
            g[1,1]=rr**2*((a1**2*rr**2+a1**2+rr**4+rr**2)*s**2+(a2**2*rr**2+a2**2+rr**4+rr**2)*c**2)/((a1**2*rr**2+a1**2+rr**4+rr**2)*(a2**2*rr**2+a2**2+rr**4+rr**2))
            g[2,2]=(-a1**2*s**2+a2**2*s**2-a2**2-rr**2)/(a1**2*s**2-a2**2*s**2+a2**2-1)
            g[3,3]=(-a1**2-rr**2)*c**2/(a1**2-1)
            g[4,4]=(-a2**2-rr**2)*s**2/(a2**2-1)
            return g
        def kv(rr): return np.array([c**2/X1+s**2/X2, rr**2/(1+rr**2)*(c**2/(rr**2+a1**2)+s**2/(rr**2+a2**2)),0,-a1*c**2/X1,-a2*s**2/X2])
        def U(rr): return (c**2/(rr**2+a1**2)+s**2/(rr**2+a2**2))*(rr**2+a1**2)*(rr**2+a2**2)
        def gf(rr,MM):
            k=kv(rr); return gbar(rr)+(2*MM/U(rr))*np.outer(k,k)
        # r(z) numerica: risolvo dr/dz = -1/(z sqrt(grr)) integrando? No: serie.
        # Uso serie simbolica in z una volta sola con x numerico (rapido perche' coeff numerici).
        zz=sp.Symbol('zz')
        a1s,a2s=A1,A2
        sR,cR=sp.Float(s),sp.Float(c)
        # grr simbolico in r con x numerico
        def gbarS(rr):
            X1s,X2s=1-a1s**2,1-a2s**2
            return ((rr**2+1)*((a1s**2-1)*sR**2+(a2s**2-1)*cR**2)/((a1s**2-1)*(a2s**2-1)),)  # placeholder
        return gf
    # --- troppo intricato numericamente per r(z); torno a semi-simbolico ma con x numerico ---
    return None

# Approccio piu' diretto: x numerico, z simbolico, coeff numerici -> series velocissima.
def run2(A1,A2,D,label):
    A1,A2=sp.Rational(A1),sp.Rational(A2)
    xs=[0.25,0.55,0.85,1.15,1.45,0.4,0.7,1.0]
    rows=[];ys=[]
    for xv in xs:
        s,c=sp.Float(np.sin(xv)),sp.Float(np.cos(xv)); X1,X2=1-A1**2,1-A2**2
        def kv(rr): return sp.Matrix([c**2/X1+s**2/X2, rr**2/(1+rr**2)*(c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2)),0,-A1*c**2/X1,-A2*s**2/X2])
        def U(rr): return (c**2/(rr**2+A1**2)+s**2/(rr**2+A2**2))*(rr**2+A1**2)*(rr**2+A2**2)
        def gbar(rr):
            g=sp.zeros(5,5)
            g[0,0]=(rr**2+1)*((A1**2-1)*s**2+(A2**2-1)*c**2)/((A1**2-1)*(A2**2-1))
            g[1,1]=rr**2*((A1**2*rr**2+A1**2+rr**4+rr**2)*s**2+(A2**2*rr**2+A2**2+rr**4+rr**2)*c**2)/((A1**2*rr**2+A1**2+rr**4+rr**2)*(A2**2*rr**2+A2**2+rr**4+rr**2))
            g[2,2]=(-A1**2*s**2+A2**2*s**2-A2**2-rr**2)/(A1**2*s**2-A2**2*s**2+A2**2-1)
            g[3,3]=(-A1**2-rr**2)*c**2/(A1**2-1); g[4,4]=(-A2**2-rr**2)*s**2/(A2**2-1)
            return g
        def gf(rr,MM):
            k=kv(rr); return gbar(rr)+(2*MM/U(rr))*(k*k.T)
        grr=gf(r,M)[1,1]
        nz=7; bs=[sp.Symbol('b%d'%k) for k in range(nz)]
        rser=1/z+sum(bs[k]*z**(2*k+1) for k in range(nz))
        e=sp.expand(z**2*((sp.diff(rser,z))**2*grr.subs(r,rser)-1/z**2))
        e=sp.series(e,z,0,2*nz).removeO(); e=sp.expand(e)
        subs={}
        for power in range(0,2*nz):
            cc=sp.expand(e.coeff(z,power)).subs(subs)
            if cc==0: continue
            unk=[b for b in bs if b in cc.free_symbols]
            if not unk: continue
            sol=sp.solve(cc,unk[0])
            if sol: subs[unk[0]]=sol[0]
        rz=rser.subs(subs)
        idx=[0,2,3,4]
        g0=sp.zeros(4,4);g4=sp.zeros(4,4);GF=gf(r,M)
        for i in range(4):
            for j in range(4):
                comp=sp.expand(sp.series((z**2*GF[idx[i],idx[j]]).subs(r,rz),z,0,6).removeO())
                g0[i,j]=comp.coeff(z,0);g4[i,j]=comp.coeff(z,4)
        g4M=sp.Matrix(4,4,lambda i,j: sp.diff(g4[i,j],M))
        mix=(g0.inv()*g4M)
        ys.append(float(mix[0,0]))
        rows.append([1,np.cos(2*xv),np.cos(4*xv),np.cos(6*xv)])
    A=np.array(rows);Y=np.array(ys)
    coef=np.linalg.lstsq(A,Y,rcond=None)[0]
    mono,quad=coef[0],coef[1]
    print("====",label,"====")
    print(" fourier[mono,cos2,cos4,cos6]=",[round(v,5) for v in coef])
    print(" quad/mono=",round(quad/mono,5)," /D=",round(quad/mono/float(D),5))

run2(1/sp.Integer(2),1/sp.Integer(5),sp.Rational(1,4)-sp.Rational(1,25),"{1/2,1/5}")
run2(1/sp.Integer(3),1/sp.Integer(5),sp.Rational(1,9)-sp.Rational(1,25),"{1/3,1/5}")
