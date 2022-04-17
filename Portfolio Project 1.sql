--SELECT *
--FROM [Portfolio Project]..CovidVaccinations
--ORDER BY 3,4

SELECT * 
FROM [Portfolio Project]..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you contract Covid-19 in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%states%'
AND continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted Covid-19

SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercetangePopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercetangePopulationInfected -- View Table
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercetangePopulationInfected DESC


-- Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location 
ORDER BY TotalDeathCount DESC

-- Let's break things down by continent

-- Showing the continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount -- View Table
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


-- Looking at total population vs vaccinations



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Using CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPoepleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

SELECT *, (RollingPoepleVaccinated/Population)*100
FROM PopvsVac

-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinatiolns numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated -- View Table 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 AS RollingPercentagePopulationVaccinated
FROM #PercentPopulationVaccinated

-- Creating View to store data for later Visualizations 


CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

CREATE VIEW	TotalDeathCount AS 
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount DESC

SELECT * 
FROM TotalDeathCount

CREATE VIEW PercentagePopulationInfected AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercetangePopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
--ORDER BY PercetangePopulationInfected DESC

SELECT *
FROM PercentagePopulationInfected