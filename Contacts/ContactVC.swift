//
//  ContactVC.swift
//  Contacts
//
//  Created by Morenikeji on 5/9/21.
//

//import Contacts
import ContactsUI
import UIKit

class ContactVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactList = [Contact]()
    var contactsWithSections = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current() // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
    var sectionTitles = [String]()
    var filterData = [Contact]()
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.sectionIndexColor = UIColor.red
        
        setupInfo()
    }
    
    @objc func setUpCollation() {
        let (arrayContacts, arrayTitles) = collation.partitionObjects(array: self.filterData, collationStringSelector: #selector(getter: Contact.name))
        self.contactsWithSections = arrayContacts as! [[Contact]]
        self.sectionTitles = arrayTitles
    }

    func setupInfo() {
        //register cell
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        tableView.separatorStyle = .none
        tableView.backgroundView = UIView()
        
        //Contact data
        contactList.append(Contact(name: "Adepegba", phone: "09099887766"))
        contactList.append(Contact(name: "Aderonke", phone: "08081234565"))
        contactList.append(Contact(name: "Beverly", phone: "09099887766"))
        contactList.append(Contact(name: "Becky", phone: "09099887766"))
        contactList.append(Contact(name: "Chioma", phone: "07022334455"))
        contactList.append(Contact(name: "Charms", phone: "07088996655"))
        contactList.append(Contact(name: "Dester", phone: "09076545345"))
        contactList.append(Contact(name: "Sandra", phone: "08021223344"))
        contactList.append(Contact(name: "Morenikeji", phone: "08077665533"))
        contactList.append(Contact(name: "Yusuff", phone: "09099887766"))
        
        filterData = contactList
        
        tableView.reloadData()
        
        setUpCollation()

    }
    
    // MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowerSearchText = searchText.lowercased()
         
        if searchText.isEmpty {
            isSearch = false
            filterData = contactList
            
            tableView.reloadData()
        } else {
            isSearch = true
            filterData = contactList.filter { ($0.name.localizedStandardContains(lowerSearchText)) }

            tableView.reloadData()
        }
    }
    
    //MARK: - Function to fetch contact from phone
    //Needs contact note field access entitlement from account holder of development team for this to work.
//    private func fetchContacts() {
//
//        let store = CNContactStore()
//
//        store.requestAccess(for: (.contacts)) { (granted, err) in
//            if let err = err{
//                print("Failed to request access",err)
//                return
//            }
//
//            if granted {
//                print("Access granted")
//                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
//                let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//
//                fetchRequest.sortOrder = CNContactSortOrder.userDefault
//
//                do {
//                    try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, error) -> Void in
//
//                        guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {return}
//                        self.contacts.append(Contact(givenName: contact.givenName, familyName: contact.familyName, mobile: phoneNumber))
//
//                    })
//
//                    for index in self.contacts.indices{
//
//                        print(self.contacts[index].givenName)
//                        print(self.contacts[index].familyName)
//                        print(self.contacts[index].mobile)
//                    }
//
//                    self.setUpCollation()
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//                catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//
//
//            } else {
//                print("Access denied")
//            }
//        }
//
//    }
    
}

extension ContactVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filterData.count
        }
        return contactsWithSections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        } else {
            return sectionTitles.count
        }
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        if isSearch == true {
            let member = filterData[indexPath.row]
            
            cell.selectionStyle = .default
            cell.name.text = member.name
            cell.phoneNo.text = member.phone

            if member.phone == "09099887766" {
                cell.logo.isHidden = false
            } else {
                cell.logo.isHidden = true
            }
        } else {
            let member = contactsWithSections[indexPath.section][indexPath.row]
            
            cell.selectionStyle = .default
            cell.name.text = member.name
            cell.phoneNo.text = member.phone

            if member.phone == "09099887766" {
                cell.logo.isHidden = false
            } else {
                cell.logo.isHidden = true
            }
        }
        
        cell.selectionStyle = .none

        return cell
    }

}

extension ContactVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionObjects(array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()

        //Array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        
        //Putting each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        
        //Sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}
