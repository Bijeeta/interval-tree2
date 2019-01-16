

IntervalTree       = require './interval-tree'
itree = new IntervalTree(300);

itree.add(22, 56,  'foo'); 

itree.add(44, 199, 'bar'); 

itree.add(1, 38,'bar2'); 
console.log itree
intervals = itree.pointSearch(2);

console.log(interval.id) for interval in intervals 
 