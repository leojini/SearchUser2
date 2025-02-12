//
//  UserCell.swift
//  SearchUserApp
//
//  Created by Leojin on 1/16/25.
//

import UIKit
import Kingfisher

protocol UserCellDelegate {
    func didTapFavoriteButton(section: Int, index: Int)
    func didTapItem(section: Int, index: Int)
}

/**
 사용자 정보 셀
 */
class UserCell: UITableViewCell {
    
    var delegate: UserCellDelegate?
    private var section = 0
    private var index = 0
    
    @IBOutlet weak var profileImageView: UIImageView! // 프로필 이미지
    @IBOutlet weak var nameLabel: UILabel! // 이름
    @IBOutlet weak var favoriteImageView: UIImageView! // 즐겨찾기 on/off 이미지
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 사용자 정보 셀을 업데이트 한다.
    ///
    /// @param section 섹션 인덱스
    /// @param index 아이템 인덱스
    /// @param name 이름
    /// @param profileUrlString 프로필 이미지 url
    /// @param isFavorite 즐겨찾기 유무
    /// @param hiddenFavorite 즐겨찾기 버튼을 보여줄 지 유무. true이면 즐겨찾기 버튼을 숨긴다.
    func update(section: Int,
                index: Int,
                name: String,
                profileUrlString: String,
                isFavorite: Bool = false) {
        self.section = section
        self.index = index
        nameLabel.text = name
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: profileUrlString),
                                     placeholder: nil,
                                     options: [.transition(.fade(0.5))],
                                     progressBlock: nil)
        // 즐겨찾기 이미지를 보여줄 경우
        favoriteImageView.image = isFavorite ? UIImage(resource: .starBlue) : UIImage(resource: .star)
    }
    
    /// 즐겨찾기 버튼을 선택했을 때 처리
    ///
    @IBAction func onFavoriteButton(_ sender: Any) {
        delegate?.didTapFavoriteButton(section: section, index: index)
    }
    
    @IBAction func onItemButton(_ sender: Any) {
        delegate?.didTapItem(section: section, index: index)
    }
}
