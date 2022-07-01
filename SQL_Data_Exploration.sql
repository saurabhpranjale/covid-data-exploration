Select *
From PortfolioProject..CovidDeaths
where continent is not null
Order By 3


--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3,4

--Looking total cases vs total deaths

Select Location, date, cast(total_cases as int) as TotalCases, cast(new_cases as int) as NewCases, cast(total_deaths as int) as TotalDeaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
Order By 1

Select Location, date, cast(total_cases as int), cast(Population as float), (cast(total_cases as float)/cast(Population as float))*100 As CasesPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
Order By 1,2

--Looking at countries with highest infection rate

Select Location,cast(Population as float) as Population, MAX(cast(total_cases as float)) As HighestInfectionCount, MAX(cast(total_cases as float)/cast(Population as float))*100 As PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where cast(Population as float) != 0
Group BY Location, Population
Order By PercentagePopulationInfected DESC

--Looking at countries with highest death counts.
Select Location, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group BY Location
Order By TotalDeathCount DESC

--Breaking down by continent
Select continent, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group BY continent
Order By TotalDeathCount DESC

--Global numbers
Select  date, SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group By date
Having SUM(cast(new_cases as float)) != 0
Order By 1

--Overal total cases
Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float))  as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 1

--looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Cast(vac.new_vaccinations as float)) over (Partition By dea.location Order By dea.location,dea.date) RollingCountofVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2


--Using CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingCountofVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Convert(float,vac.new_vaccinations)) over (Partition By dea.location Order By dea.location,
 dea.date) RollingCountofVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2
)
Select *, (Cast(RollingCountofVaccinations as float)/cast(Population as float)*100) as PercentPopulationVaccinated
From PopvsVac 
Where cast(Population as float) != 0



--Creating view to store data for later visualizations

Create View PercentPopulationVaccinataions as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Convert(float,vac.new_vaccinations)) over (Partition By dea.location Order By dea.location,
 dea.date) RollingCountofVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2

Select * 
From PercentPopulationVaccinataions