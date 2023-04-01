Select *
From PortfolioProject..CovidDeaths

Select *
From CovidVaccinations

alter table CovidDeaths
alter column total_deaths float;

-- Percentage of infected population
Select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%nigeria%'
order by 1,2


-- Looking at population against deaths
Select location, population, MAX(total_deaths) TotalDeaths, MAX((total_deaths/population)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%nigeria%'
group by location, population
order by DeathPercentage desc





-- Continent level
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--Continents with the highest deathCounts
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
group by date
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3






