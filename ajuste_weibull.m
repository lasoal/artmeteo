%%
%Función: [c,k,s]=ajuste_weibull (R)
%Autor: Alberto Laso Pérez, GTEA, Universidad de Cantabria
%Fecha: 25/09/2016
%Versión: 1.01
    %La función devuelve la salida del factor de escala s
    %Se añade leyenda a las dos gráficas y se pone en inglés
%Versión: 1.00 (20/09/2016)


%La función ajusta una función de distribución de weibull a 
%una colección de valores R de dimensión nx1 a devuelve los coeficientes c y k
%siendo d=0 :

%       k: factor de forma 
%       c: factor de escala 
%       d: parámetro de posición

%Además, devuelve el factor de escala s entre la distribución de valores y
%la de frecuencias tal que
%s*hist(R,intervalos)=s*bar(intervalos,frecuencia)

% la ecuación que ajusta es:

% f(x)=(k/c)*[(x/c)^(k-1)]*e^((-(x/c))^k ),x>0


%ejemplo
%c=3;k=1.5;
%R = wblrnd(c,k,13000,1);
%[c k s]=ajuste_weibull(R);

%%%%%%%%%%%%%%%%%%%%%%%%%

%Functión: [c,k,s]=ajuste_weibull (R)
%Author: Alberto Laso Pérez, GTEA, University of Cantabria
%Date: 25/09/2016
%Version: 1.01
    %Function now returns scale factor s
    %Labels in English are added to both figures
%Version: 1.00 (20/09/2016)


%The function fits a weibull distribution to a series of values R with size nx1 a una
%and returns coeficients c and k with d=0:

%       k: shape parameter 
%       c: scale parameter 
%       d: position parameter

%It also returns scale factor s between the values and the frequencies
%distribution so that
%s*hist(R,intervalos)=s*bar(intervalos,frecuencia)

% The ecuation to fit is:

% f(x)=(k/c)*[(x/c)^(k-1)]*e^((-(x/c))^k ),x>0
 

%example
%c=3;k=1.5;
%R = wblrnd(c,k,13000,1);
%[c k s]=ajuste_weibull(R);

%%
function [c,k,s]=ajuste_weibull (R)

num_intervalos=100; %número de intervalos para el eje x
num_max_iter=10000;%número máximo de iteraciones para el ajuste

val_max=max(R); %valores máximo y mínimo de entrada (velocidad en viento)
val_min=min(R);
num_valores=length(R);


intervalos=linspace(val_min, val_max,num_intervalos); %vector intervalos(velocidades en caso de viento)
figure(1)
hold on
hist(R,intervalos)%pintar histograma de datos según intervalo
title('Source Values')
xlabel('Speed')
ylabel('Repetitions')

repeticiones=hist(R,length(intervalos)); %obtengo historial de repeticiones
frecuencia=zeros(1,length(intervalos));
for i=1:1:length(intervalos)
    frecuencia(i)=repeticiones(i)/num_valores; %obtengo frecuencia de repetición para cada intervalo
end
% frec_acum=cumsum(frecuencia); % obtengo la frecuencia acumulada
% figure(2)
% plot(frec_acum)
%%%%%ajustamos a(1)=k a(2)=c
x=intervalos;
f=@(a,x) a(3)*(a(1)/a(2))*((x/a(2)).^(a(1)-1)).*exp(-(x/a(2)).^a(1));
a0=[2 1 1];  %valor inicial de los parámetros
opts = statset('MaxIter',num_max_iter); %número máximo de iteraciones
af=nlinfit(x,frecuencia,f,a0,opts);

%diagrama de frecuencias
figure(2)
hold on
bar(intervalos,frecuencia,'c');

%representa la curva de ajuste
x=linspace(val_min,val_max,1000);
y=f(af,x);
plot(x,y,'r')

title('Weibull fit')
xlabel('Speed')
ylabel('Frequency')
hold off

c=af(2);
k=af(1);
s=af(3);

end