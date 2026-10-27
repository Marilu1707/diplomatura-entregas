# Diplomatura en Data Science · Entregas

**María Luján Massironi** · Coderhouse

Todas las entregas de la diplomatura, ordenadas por materia y por entrega. Casi todos los proyectos trabajan sobre el mismo caso de negocio: **La Feria del Automóvil**, una feria de compra y venta de autos usados. Cada materia lo mira desde otra herramienta: modelo de datos, dashboards, IA generativa, gestión ágil.

## Materias

| Materia | Proyecto | Herramientas | Entregas |
|---------|----------|--------------|----------|
| [Data Analytics](./data-analytics/) | Oferta de autos usados de la Feria del Automóvil | Excel, draw.io, Power BI | 1, 2, 3 y final |
| [Excel](./excel/) | Dashboard interactivo de publicaciones de autos | Excel (Power Query, tablas dinámicas) | Pre-entrega y final |
| [SQL](./sql/) | Base de datos relacional del inventario de vehículos | MySQL 8, esquema estrella | 1, 2 y final |
| [Power BI](./power-bi/) | Dashboard de inventario y precios | Power BI Desktop | Pre-entrega y final |
| [Tableau](./tableau/) | Visualización del dataset de autos | Tableau | 1 y final |
| [Looker Studio](./looker-studio/) | Performance comercial digital del sitio de la feria (GA4) | Looker Studio, Google Analytics 4 | 1 y final |
| [Data Science I](./data-science-i/) | Respuesta a campañas de marketing (2.240 clientes) | Python, pandas, scikit-learn | Parte I y Parte III |
| [Data Science II](https://github.com/Marilu1707/nido-mozzarella-data-science) | Nido Mozzarella: pronóstico de producción de quesos | Python, APIs públicas, ML, SHAP | Pre-entrega y final (repo propio) |
| [IA: Generación de Prompts](./generacion-de-prompts/) | Generación inteligente de leads para la feria | Prompt engineering, Jupyter | 1 y 2 |
| [Inteligencia Artificial](./inteligencia-artificial/) | Pipeline de contenido con IA generativa para la feria | Texto, imagen, audio y video con IA | Pre-entrega y final |
| [Metodologías Ágiles](./metodologias-agiles/) | Plataforma de captación de leads con Scrum | Scrum | Pre-entrega 2 y final |
| [Cultura Digital](./cultura-digital/) | Feria Auto Leads: idea de negocio digital | Estrategia digital | Final |

## Estructura

```
diplomatura-entregas/
├── data-analytics/
│   ├── entrega-1/        Planteo SMART y dataset
│   ├── entrega-2/        Objetivos, diagrama entidad-relación y primer tablero
│   ├── entrega-3/        Tablero en Power BI
│   └── entrega-final/    Informe técnico y tablero final
├── excel/
│   ├── pre-entrega/      Proyecto parcial
│   └── entrega-final/    Dashboard y documentación
├── sql/
│   ├── entrega-1/        Introducción, esquema y DER
│   ├── entrega-2/        Informe de avance
│   └── entrega-final/    Informe, DER, scripts (schema, datos, vistas/funciones/SP/triggers) y datos
├── power-bi/
├── tableau/
├── looker-studio/
│   ├── entrega-1/        Presentación y brief
│   └── entrega-final/    Presentación, documentación del dashboard, reporte y brief
├── data-science-i/       Notebooks Parte I (EDA) y Parte III (modelado)
├── generacion-de-prompts/
├── inteligencia-artificial/
│   ├── pre-entrega/      Descripción, imágenes generadas y audio
│   └── entrega-final/    Descripción del trabajo
├── metodologias-agiles/
└── cultura-digital/
```

## Notas por materia

### Data Analytics
Análisis de la oferta de autos usados: precio, marca, modelo, año, kilometraje, combustible, transmisión y ubicación. El trabajo pasa por el planteo SMART, el modelo de datos (ERD en draw.io) y el tablero final en Power BI.

### SQL
Base de datos relacional para el inventario de vehículos, con una tabla de hechos y dimensiones (marca, modelo, combustible, transmisión, color, carrocería, ubicación, estado, origen y fecha). En la entrega final se suman vistas, funciones, stored procedures y triggers. Para correrlo en MySQL Workbench, ejecutar en orden `01_schema.sql`, `02_datos.sql` y `03_objetos.sql`.

### Looker Studio
Tablero de performance comercial digital del sitio feriadelautomovil.com.ar con datos de Google Analytics 4 (septiembre a diciembre de 2025): 6 páginas, 9 gráficos y 4 fuentes GA4.

### Data Science I
Dataset de campañas de marketing con 2.240 clientes. La Parte I es un análisis exploratorio de los factores asociados a la respuesta a las campañas. La Parte III construye modelos predictivos a partir de esas variables.

### Data Science II
Está en su propio repositorio: [nido-mozzarella-data-science](https://github.com/Marilu1707/nido-mozzarella-data-science). Cruza datos del INDEC, clima, feriados e inflación para pronosticar la producción mensual de quesos con modelos de ML optimizados.

### Inteligencia Artificial
Proyecto integrador de IA generativa sobre la generación de leads para la feria: texto, imágenes, audio y presentación hecha con IA. Dos archivos no entran en el repo por tamaño:
- **Video final** (564 MB): [ver en Google Drive](https://drive.google.com/file/d/1k-m5iWeO3y1djQNkxAdY7nnGIuUwnYo4/view)
- **Presentación de la pre-entrega** (27 MB): está en Google Drive, en la carpeta de la materia.

### Oratoria
Las entregas se hicieron en Canva y en el campus de Coderhouse. Pre-entrega 3: [presentación en Canva](https://canva.link/klc03cz9of7dmj3).
