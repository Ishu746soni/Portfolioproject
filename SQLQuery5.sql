select* from portfolioproject.dbo.CovidDeaths

select location,date,total_cases,new_cases,total_deaths,population from portfolioproject.dbo.CovidDeaths order by 1,2

--looking at total death vs total cases
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage from portfolioproject.dbo.CovidDeaths 
where location='India' order by 1,2

--looking at total cases vs population
select location,date,population,total_cases,(total_cases/population)*100 as casespercentage from portfolioproject.dbo.CovidDeaths 
where location='India' order by 1,2

--looking at countries with highest infectious rate compared to population 
select location,population,max(total_cases) as highestinfectiousrate,max((total_cases/population))*100 as highestinfectiouspercentage from
portfolioproject.dbo.CovidDeaths group by location,population order by highestinfectiouspercentage desc

--showing countries with highest death count per population
select location,max(cast(total_deaths as int)) as totaldeathcount from  portfolioproject.dbo.CovidDeaths 
group by location order by totaldeathcount desc

--showing the continent with the highest death count
select location,continent,max(cast(total_deaths as int)) as totaldeathcount from  portfolioproject.dbo.CovidDeaths where continent is null 
group by location,continent order by totaldeathcount desc

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_death,sum(cast(new_deaths as int))/sum(new_cases)*100 
as deathpercentage from portfolioproject.dbo.CovidDeaths where continent is not null

select*from portfolioproject.dbo.CovidVaccinations

--join both the tables
select * from portfolioproject.dbo.CovidDeaths as cd join portfolioproject.dbo.CovidVaccinations as cv on cd.location = cv.location 
and cd.date = cv.date

--looking at total population vs vacciantions
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(new_vaccinations as int)) 
over (partition by cd.location) as sum_of_nvc 
from portfolioproject.dbo.CovidDeaths as cd join portfolioproject.dbo.CovidVaccinations as cv 
on cd.location = cv.location and cd.date = cv.date where cd.continent is not null 


--using cte table pop vs vacc
with popvsvac(continent,location,date,population,new_vaccination,sum_of_nvc)
as (
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date) as sum_of_nvc 
from portfolioproject.dbo.CovidDeaths as cd join portfolioproject.dbo.CovidVaccinations as cv 
on cd.location = cv.location and cd.date = cv.date where cd.continent is not null 
)
select*,(sum_of_nvc/population)*100 as percentsum from popvsvac


--using temp table
    --drop table if exists #percentpopulationvaccinated  (if have done some alteration in data then first run this command then it doesnot gives the error)
create table #percentpopulationvaccinated(continent varchar(255),location varchar(255),date datetime,population numeric,
new_vaccinations numeric,sum_of_nvc numeric)
insert into #percentpopulationvaccinated
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date) as sum_of_nvc 
from portfolioproject.dbo.CovidDeaths as cd join portfolioproject.dbo.CovidVaccinations as cv 
on cd.location = cv.location and cd.date = cv.date where cd.continent is not null 
select*,(sum_of_nvc/population)*100 as percentsum from #percentpopulationvaccinated


--creating view for visualization
create view percentpopulationvaccinated as 
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date) as sum_of_nvc 
from portfolioproject.dbo.CovidDeaths as cd join portfolioproject.dbo.CovidVaccinations as cv 
on cd.location = cv.location and cd.date = cv.date where cd.continent is not null 
select* from percentpopulationvaccinated