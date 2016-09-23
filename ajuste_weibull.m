%%
%Funci�n: [c,k]=ajuste_weibull (R)
%Autor: Alberto Laso P�rez, GTEA, Universidad de Cantabria
%Fecha: 20/09/2016
%Versi�n: 1.0

%La funci�n ajusta una funci�n de distribuci�n de weibull a 
%una colecci�n de valores R de dimensi�n nx1 a devuelve los coeficientes c y k
%siendo ?=0 :

%       k: factor de forma 
%       c: factor de escala 
%       ?: par�metro de posici�n

% la ecuaci�n que ajusta es:

% f(x)=(k/c)*[(x/c)^(k-1)]*e^((-(x/c))^k ),x?0

%ejemplo
%c=3;k=1.5;
%R = wblrnd(c,k,13000,1);
%[c k]=ajuste_weibull(R);

%%%%%%%%%%%%%%%%%%%%%%%%%

%Functi�n: [c,k]=ajuste_weibull (R)
%Author: Alberto Laso P�rez, GTEA, University of Cantabria
%Date: 20/09/2016
%Version: 1.0

%The function fits a weibull distribution to a series of values R with size nx1 a una
%and returns coeficients c and k with ?=0:

%       k: shape parameter 
%       c: scale parameter 
%       ?: position parameter

% The ecuation to fit is:

% f(x)=(k/c)*[(x/c)^(k-1)]*e^((-(x/c))^k ),x?0

%example
%c=3;k=1.5;
%R = wblrnd(c,k,13000,1);
%[c k]=ajuste_weibull(R);

%%
function [c,k]=ajuste_weibull (R)

num_intervalos=100; %n�mero de intervalos para el eje x
num_max_iter=10000;%n�mero m�ximo de iteraciones para el ajuste

val_max=max(R); %valores m�ximo y m�nimo de entrada (velocidad en viento)
val_min=min(R);
num_valores=length(R);


intervalos=linspace(val_min, val_max,num_intervalos); %vector intervalos(velocidades en caso de viento)
figure(1)
hist(R,intervalos)%pintar histograma de datos seg�n intervalo


repeticiones=hist(R,length(intervalos)); %obtengo historial de repeticiones
frecuencia=zeros(1,length(intervalos));
for i=1:1:length(intervalos)
    frecuencia(i)=repeticiones(i)/num_valores; %obtengo frecuencia de repetici�n para cada intervalo
end
% frec_acum=cumsum(frecuencia); % obtengo la frecuencia acumulada
% figure(2)
% plot(frec_acum)
%%%%%ajustamos a(1)=k a(2)=c
x=intervalos;
f=@(a,x) a(3)*(a(1)/a(2))*((x/a(2)).^(a(1)-1)).*exp(-(x/a(2)).^a(1));
a0=[2 1 1];  %valor inicial de los par�metros
opts = statset('MaxIter',num_max_iter); %n�mero m�ximo de iteraciones
af=nlinfit(x,frecuencia,f,a0,opts);

%diagrama de frecuencias
figure(3)
hold on
bar(intervalos,frecuencia,'c');

%representa la curva de ajuste
x=linspace(val_min,val_max,1000);
y=f(af,x);
plot(x,y,'r')

title('Ajuste a la funci�n Weibull')
xlabel('Velocidad')
ylabel('Frecuencia')
hold off

c=af(2);
k=af(1);

end