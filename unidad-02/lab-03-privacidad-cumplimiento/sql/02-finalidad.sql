-- Diseña una consulta que proporcione información agregada:
SELECT ciudad, COUNT(*) AS cantidad_clientes FROM clientes GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

-- Ahora crea rangos de edad:
SELECT CASE
    WHEN edad &lt; 18 THEN &#39;Menor de 18&#39;
    WHEN edad BETWEEN 18 AND 29 THEN &#39;18-29&#39;
    WHEN edad BETWEEN 30 AND 44 THEN &#39;30-44&#39;
    WHEN edad BETWEEN 45 AND 59 THEN &#39;45-59&#39; ELSE &#39;60 o más&#39;
END AS rango_edad, COUNT(*) AS cantidad FROM clientes
GROUP BY CASE
    WHEN edad &lt; 18 THEN &#39;Menor de 18&#39;
    WHEN edad BETWEEN 18 AND 29 THEN &#39;18-29&#39;
    WHEN edad BETWEEN 30 AND 44 THEN &#39;30-44&#39;
    WHEN edad BETWEEN 45 AND 59 THEN &#39;45-59&#39;
ELSE &#39;60 o más&#39; END ORDER BY rango_edad;

