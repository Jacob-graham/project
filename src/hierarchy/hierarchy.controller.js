
const dbService = require('../db/db.service');

function getHierarchyForId(id) {
   // Check if member exists, then get hierarchy
   dbService.getHierarchyItemById(id).then((member) => {
      const memberHierarchy = []
      getMemberHierarchy(member, memberHierarchy)
      setTimeout(() => {
         const str = memberHierarchy.map(m => m.name).reverse().join(' --> ')
         console.log(str);
         return str;
      }, 0);
   }).catch(err => console.error('No member with Id = ', id));
}

function getMemberHierarchy(member, memberHierarchy, i=0) {
   if (i > member.level) return memberHierarchy; // done
   dbService.getHierarchyItemById(member.parentMemberId).then((parentMember) => {
      memberHierarchy.push(parentMember)
      getMemberHierarchy(parentMember, memberHierarchy, i+1);
   })
};

module.exports = {
   getHierarchyForId
};
