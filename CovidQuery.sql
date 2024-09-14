Select *
From CovidVisual..CovidDeaths$
order by 3,4

--Select *
--From CovidVisual..CovidVacinnation$
--order by 3,4

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidVisual..CovidDeaths$
--Where location like '%states%'
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidVisual..CovidDeaths$
Where location like '%states%'
and continent is not null 
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidVisual..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidVisual..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidVisual..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidVisual..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Using CTE to perform Calculation on Partition By in previous query
-- calculates the average number of deaths per year (2020 to 2023) for each continent, location, and date 
WITH cteneo AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    SUM(CASE WHEN YEAR(date) = 2020 THEN total_deaths ELSE 0 END) AS dea_2020,
    SUM(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE 0 END) AS dea_2021,
    SUM(CASE WHEN YEAR(date) = 2022 THEN total_deaths ELSE 0 END) AS dea_2022,
    SUM(CASE WHEN YEAR(date) = 2023 THEN total_deaths ELSE 0 END) AS dea_2023,
    COUNT(CASE WHEN YEAR(date) = 2020 THEN total_deaths ELSE NULL END) AS cnt_2020,
    COUNT(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE NULL END) AS cnt_2021,
    COUNT(CASE WHEN YEAR(date) = 2022 THEN total_deaths ELSE NULL END) AS cnt_2022,
    COUNT(CASE WHEN YEAR(date) = 2023 THEN total_deaths ELSE NULL END) AS cnt_2023
  FROM
    CovidVisual..CovidDeaths$ dea
  GROUP BY
    continent,
	location,
	date,
	population
)
SELECT
  continent,
  location,
  date,
  population,
  ROUND((
      dea_2020 + dea_2021 + dea_2022 + dea_2023
    ) / (
      CASE WHEN cnt_2020 = 0 THEN 1 ELSE cnt_2020 END +
      CASE WHEN cnt_2021 = 0 THEN 1 ELSE cnt_2021 END +
      CASE WHEN cnt_2022 = 0 THEN 1 ELSE cnt_2022 END +
      CASE WHEN cnt_2023 = 0 THEN 1 ELSE cnt_2023 END
    ), 2) AS avg_deaths
FROM
  cteneo
ORDER BY
  1;

--cte


With cte (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVisual..CovidDeaths$ dea
Join CovidVisual..CovidVacinnation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From cte

--Display average deaths for each continent between 2019 and 2021

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVisual..CovidDeaths$ dea
Join CovidVisual..CovidVacinnation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Creating View to store data for later visualizations
GO
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVisual..CovidDeaths$ dea
Join CovidVisual..CovidVacinnation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
GO

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidVisual..CovidDeaths$ dea
Join CovidVisual..CovidVacinnation$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated