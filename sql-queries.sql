1.(A) How many types of tigers can be found in the taxonomy table of the dataset? 
-> select count(*) as tiger_count from taxonomy where species ;
->+-------------+
  | tiger_count |
  +-------------+
  |          50 |
  +-------------+
1 row in set, 65535 warnings (0.754 sec)
(B) What is the "ncbi_id" of the Sumatran Tiger?
-> select ncbi_id from taxonomy where species LIKE '%Panthera_tigris_sumatrae%';
  +---------+
  | ncbi_id |
  +---------+
  |    9695 |
  +---------+
1 row in set (0.520 sec)

2. Find all the columns that can be used to connect the tables in the given database.
taxonomy.ncbi_id ↔ rfamseq.ncbi_id
rfamseq.rfamseq_acc ↔ full_region.rfamseq_acc
family.rfam_acc ↔ full_region.rfam_acc
family.rfam_acc ↔ clan_membership.rfam_acc
clan.clan_acc ↔ clan_membership.clan_acc

3. Which type of rice has the longest DNA sequence? 
->SELECT t.species, MAX(r.length) AS max_length
  FROM rfamseq r
  JOIN taxonomy t ON r.ncbi_id = t.ncbi_id
  WHERE t.species LIKE 'Oryza sativa%'
  GROUP BY t.species
  ORDER BY max_length DESC
  LIMIT 1;
  | species                   | max_length |
  +---------------------------+------------+
  | Oryza sativa Indica Group |   47244934 |
  +---------------------------+------------+
1 row in set (0.270 sec)
    
4. We want to paginate a list of the family names and their longest DNA sequence lengths (in descending order of length) where only families that have DNA sequence lengths greater than 1,000,000 are included. Give a query that will return the 9th page when there are 15 results per page. (hint: we need the family accession ID, family name and the maximum length in the results)
->     SELECT f.rfam_acc, f.rfam_id, MAX(r.length) AS max_length
    -> FROM family f
    -> JOIN full_region fr ON f.rfam_acc = fr.rfam_acc
    -> JOIN rfamseq r ON fr.rfamseq_acc = r.rfamseq_acc
    -> WHERE r.length > 1000000
    -> GROUP BY f.rfam_acc, f.rfam_id
    -> ORDER BY max_length DESC
    -> LIMIT 15 OFFSET 120;

+----------+-----------+------------+
| rfam_acc | rfam_id   | max_length |
+----------+-----------+------------+
| RF00135  | snoZ223   |  836514780 |
| RF00097  | snoR71    |  836514780 |
| RF00012  | U3        |  836514780 |
| RF00445  | mir-399   |  836514780 |
| RF01208  | snoR99    |  836514780 |
| RF00337  | snoZ112   |  836514780 |
| RF03674  | MIR5387   |  836514780 |
| RF01848  | ACEA_U3   |  836514780 |
| RF00030  | RNase_MRP |  836514780 |
| RF00267  | snoR64    |  836514780 |
| RF00350  | snoZ152   |  836514780 |
| RF00145  | snoZ105   |  830829764 |
| RF00451  | mir-395   |  801256715 |
| RF00329  | snoZ162   |  801256715 |
| RF01424  | snoR118   |  801256715 |
+----------+-----------+------------+
15 rows in set (1 min 39.816 sec)
