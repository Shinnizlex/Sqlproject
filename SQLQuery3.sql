Select *
From ProjectDatabase..CovidDeaths
Where continent is not null
Order By 3,4

--Select *
--From ProjectDatabase..CovidVaccinations
--Order By 3,4


---------Select data that we are going to using-----
Select Location, date, total_cases, new_cases, total_deaths, population
From ProjectDatabase..CovidDeaths
Where continent is not null
Order by 1,2


---------Looking at total vs total deaths------

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From ProjectDatabase..CovidDeaths
Where location like '%State%'
and continent is not null
Order by 1,2

------ looking at total cases vs population--------
-------Shows What percentage of the population got covid----

Select Location, date, population, Max(total_cases) as HighestInfectioncount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From ProjectDatabase..CovidDeaths
--Where location like '%State%'
Where continent is not null
Order by 1,2

-------------- Looking at countries with the highest infection Rate compared to population--------
Select Location, population, Max(total_cases) as HighestInfectioncount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From ProjectDatabase..CovidDeaths
--Where location like '%State%'
Where continent is not null
Group By Location, population
Order by PercentagePopulationInfected desc


--------Showing Countries with the highest Death count per population---
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From ProjectDatabase..CovidDeaths
--Where location like '%State%'
Where continent is not null
Group By Location
Order by TotalDeathCount desc

------ Break thinks by continent----
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From ProjectDatabase..CovidDeaths
--Where location like '%State%'
Where continent is  null
Group By location
Order by TotalDeathCount desc

----Global Numbers---

	Select  Sum(new_cases)as total_cases, SUM(cast(new_deaths as int))as total_death, SUM(cast(new_deaths as int))/SUM (New_cases)*100 as Deathpercentage
	From ProjectDatabase..CovidDeaths
	---Where location like '%State%'
	Where continent is not null
	--Group by date
	Order by 1,2
	----- Looking at total population Vs vaccinations
	WITH PopvsVac (Continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM (cast( vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) As Rollingpeoplevaccinated
	---, (RollingpeopleVacinated/population)*100
	from ProjectDatabase..CovidDeaths dea
	join ProjectDatabase..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 Where dea.continent is not null
	 )
	 select* 
	 from PopvsVac


 ------ temp table
 DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Contient Nvarchar (255),
Location nvarchar (255),
date datetime,
population numeric, 
New_vaccinations numeric,
RollingpeopleVacinated numeric
)
Insert into #PercentPopulationVaccinated


 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM (cast( vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) As Rollingpeoplevaccinated
	---, (RollingpeopleVacinated/population)*100
	from ProjectDatabase..CovidDeaths dea
	join ProjectDatabase..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 ---Where dea.continent is not null
	--- Order by 2,3

	-----Create a View to store data for visualitation--
     
		create view PercentPopulationVaccinate as 
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
		, SUM (cast( vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) As Rollingpeoplevaccinated
		---, (RollingpeopleVacinated/population)*100
		from ProjectDatabase..CovidDeaths dea
		join ProjectDatabase..CovidVaccinations vac
		 on dea.location = vac.location
		 and dea.date = vac.date
		 Where dea.continent is not null
		 --Order by 2,3

		 Select* 
		 From PercentPopulationVaccinate