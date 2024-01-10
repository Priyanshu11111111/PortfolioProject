select * from portfolioProject..CovidDeaths
Where continent is not null
order by 3,4
select * from portfolioProject..CovidVaccinations
order by 3,4

--select * from portfolioProject..CovidVaccinations
--order by 3,4

--Select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population
from portfolioProject..CovidDeaths
Where continent is not null
order by 1,2


--Looking at Total Cases VS Total Deaths
--Shows likelihood of dying if you contract covid in your country


select Location,date, total_cases, total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from  portfolioProject..CovidDeaths
where location like '%state%'

--Looking at total cases Vs Population
--Show What Percentages of population got covid 


select Location,date, total_cases, population,(total_cases/population)*100 as CovidPeople
from  portfolioProject..CovidDeaths
where location like '%state%'


--Looking Country With Highest In fection rate Compared to population 

select Location, population,
MAX(total_cases)as HighestInfectionCount , 
Max((total_cases/population))*100 as  Percentpopulationinfected
from  portfolioProject..CovidDeaths
--where location like '%state%
Group by location,population
order by Percentpopulationinfected desc


--Showint the country wiyh the death count per population 

select location ,MAX(cast(total_deaths as int)) as TotalDeathCount
from  portfolioProject..CovidDeaths
Where continent is not null
group by location
order by TotalDeathCount desc


--Breake it into continent

select location ,MAX(cast(total_deaths as int)) as TotalDeathCount
from  portfolioProject..CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc


select continent ,MAX(cast(total_deaths as int)) as TotalDeathCount
from  portfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Showint the continent with high Death Count per population      

select continent ,MAX(cast(total_deaths as int)) as TotalDeathCount
from  portfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Breaking GLOBAL NUMBER

select date, sum(new_cases) as Total_Cases,sum(cast(new_deaths as int)) as Total_Death ,sum(cast(new_deaths as int)) /sum(new_cases)*100 
as AVG_Case_Death
from  portfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
group by date
order by 1,2

select  sum(new_cases) as Total_Cases,sum(cast(new_deaths as int)) as Total_Death ,sum(cast(new_deaths as int)) /sum(new_cases)*100 
as AVG_Case_Death
from  portfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
--group by date
order by 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATION  very important
select dea.continent,dea.location,dea.date,population, vac.new_vaccinations 
,sum(convert(int,vac. new_vaccinations))over(partition By dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated,

from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3



--with cte

with PopvsVac (Continent,location,date,population,new_vaccination,RollingPeopleVaccination)
as
(
select dea.continent,dea.location,dea.date,population, vac.new_vaccinations 
,sum(convert(int,vac. new_vaccinations))over(partition By dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select*,(RollingPeopleVaccination/population)*100
from PopvsVac


---Usint Tem Table

create table #PercentPopulationVaccinated
(
contintent varchar(225),
Location varchar(225),
Date datetime,
Population int,
New_Vaccination int,
RollingPeopleVaccination int
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,population, vac.new_vaccinations 
,sum(convert(int,vac. new_vaccinations))over(partition By dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*,(RollingPeopleVaccination/population)*100
from #PercentPopulationVaccinated


--creatint View to store Data For later Visualizations

Create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,population, vac.new_vaccinations 
,sum(convert(int,vac. new_vaccinations))over(partition By dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select * from PercentPopulationVaccinated