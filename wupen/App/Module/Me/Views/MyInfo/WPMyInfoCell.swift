//
//  WPMyInfoCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPMyInfoCell: UITableViewCell {
    
    class func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,datas:[WPMyInfoModel]) -> UITableViewCell {
        let model:WPMyInfoModel = datas[indexPath.section]
        let cell:WPMyInfoCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPMyInfoCell
        cell.model = model
        return cell
    }
    
    class func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,datas:[WPMyInfoModel], view:UIView) {
        let model:WPMyInfoModel = datas[indexPath.section]
        self.didModel(model, tableView: tableView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    var model:WPMyInfoModel!{
        didSet {
            self.textLabel?.text = model.title
            self.detailTextLabel?.text = model.text
            userHead.isHidden = true
            if model.type == .avatar {
                model.updateHeaderImageBlock = .some({[weak self] img in
                    guard let weakSelf = self else { return }
                    weakSelf.userHead.image = img
                })
                
                let userInfo = WPUser.user()?.userInfo
                self.userHead.sd_setImage(with: URL(string: userInfo?.profilePhoto ?? ""))
            }
            
            if model.rightType == .image {
                userHead.isHidden = false
                self.accessoryType = .disclosureIndicator
                self.accessoryView = nil
                
            } else if model.rightType == .arrow  {
                self.accessoryType = .disclosureIndicator
                self.accessoryView = nil
                
            } else if model.rightType == .copy  {
                self.accessoryType = .disclosureIndicator
                self.accessoryView = self.arrow
                
            } else {
                self.accessoryType = .none
                self.accessoryView = nil
            }
        }
    }
    
    lazy var userHead: UIImageView = {
        var userHead: UIImageView = UIImageView()
        userHead.isHidden = true
        userHead.contentMode = .scaleAspectFill
        userHead.layer.cornerRadius = 22
        userHead.clipsToBounds = true
        userHead.backgroundColor = .systemGray
        contentView.addSubview(userHead)
        return userHead
    }()
    
    lazy var arrow: UIButton = {
        var arrow: UIButton = UIButton()
        arrow.setImage(.init(named: "复制"), for: .normal)
        arrow.size = CGSize(width: 21, height: 44)
        arrow.contentHorizontalAlignment = .right
        arrow.tintColor = rgba(102, 102, 102, 0.5)
        arrow.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let text = self?.model.text else { return  }
            UIPasteboard.general.string = text
            self?.showMessage("学号已复制")
      
        }).disposed(by: disposeBag)
        return arrow
    }()
}

extension WPMyInfoCell {
    func makeSubViews() -> Void {
        self.backgroundColor = .white
        self.textLabel?.textColor = rgba(51, 51, 51, 1)
        self.textLabel?.font = .systemFont(ofSize: 14)
        
        self.detailTextLabel?.textColor = rgba(102, 102, 102, 1)
        self.detailTextLabel?.font = .systemFont(ofSize: 14)
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = .init(width: -1, height: -2)
        self.layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.contentView.layer.shadowRadius = 5
    }
    
    func makeConstraints() -> Void {
        userHead.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-7)
        }
    }
}


extension WPMyInfoCell {
    class func didModel(_ model:WPMyInfoModel,tableView:UITableView) -> Void {
        if model.type == .avatar {
            let headSheetView:WPUploadHeadSheetView = WPUploadHeadSheetView()
            headSheetView.show()
            headSheetView.didSelectedBlock = .some({ x in
                let picker = UIImagePickerController()
                picker.modalPresentationStyle = .fullScreen
                picker.modalTransitionStyle = .crossDissolve
                //设置代理
                picker.delegate = model
                //指定图片控制器类型
                picker.sourceType = x
                picker.imageExportPreset = .current
                //弹出控制器，显示界面
                tableView.yy_viewController?.present(picker, animated: true, completion: nil)
            })
            
        } else if model.type == .birthday {
            let user = WPUser.user()
            let birthdayView = WPBirthdayView()
            if let birthday = user?.userInfo?.birthday {
                let date = Date.jk.formatterTimeStringToDate(timesString: birthday, formatter: "yyyy-MM-dd")
                birthdayView.datePicker.date = date
            }
            birthdayView.show()
            birthdayView.didSelectedBlock = .some({ date in
                let dateStr = date.jk.toformatterTimeString(formatter: "yyyy-MM-dd")
                WPUser.userSaveMark(birthday: dateStr) { jsmo in
                    if jsmo.jsonModel?.success == true {
                        user?.userInfo?.birthday = dateStr
                        model.text = dateStr
                        tableView.reloadData()
                    }
                }
            })
        } else if model.type == .sex {
            let sexSheetView = WPSexSheetView()
            sexSheetView.show()
            sexSheetView.didSelectedBlock = .some({ sex in
                WPUser.userSaveMark(gender: sex) { jsmo in
                    if jsmo.jsonModel?.success == true {
                        if (sex == 1) {
                            model.text = "男"
                        } else if (sex == 0) {
                            model.text = "女"
                        }
                        tableView.reloadData()
                    }
                }
            })
        } else if model.type == .nickname {
            /*
            let nameSheetView = WPNickNameEditeSheetView()
            nameSheetView.show()
            nameSheetView.didSelectedBlock = .some({ name in
                WPUser.userSaveMark(username: name) { jsmo in
                    if jsmo.jsonModel?.success == true {
                        model.text = name
                        tableView.reloadData()
                    }
                }
            })
             */
        } else if model.type == .other {
            let vc:WPRegisterAcountController = WPRegisterAcountController()
            tableView.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}
