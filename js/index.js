var app, areaID, filterArea, getProfile, getUrlQueryString, getWorkPeple, hopeArea, optionArea, profileCard, resume, scrollTopClick, scrollTopID, updateProfile, workID;

app = document.getElementById('app');

areaID = document.getElementById('area');

workID = document.getElementById('work');

scrollTopID = document.getElementById('scroll-top');

resume = {
  hasWorkCount: 300,
  zone: '',
  job: '',
  // 1 = 地區
  // 2 = 職業
  // 3 = 兩者皆有
  status: '0',
  profileUserData: []
};

getUrlQueryString = function() {
  var queryArr1, url;
  url = window.location.href;
  if (url.indexOf('?') !== -1) {
    queryArr1 = url.split('?')[1].split('&');
    queryArr1.forEach(function(item, index) {
      if (item.split('=')[0] === 'area') {
        resume.zone = decodeURI(item.split('=')[1]);
        resume.status = '1';
      } else if (item.split('=')[0] === 'job') {
        resume.job = decodeURI(item.split('=')[1]);
        resume.status = '2';
      }
    });
    if (resume.zone && resume.job) {
      resume.status = '3';
    }
  }
};

getProfile = function() {
  var getProfileAJAX, getWorkAjax, profileUrl, workUrl;
  profileUrl = 'https://raw.githubusercontent.com/hexschool/Resume/master/profile.json';
  workUrl = 'https://raw.githubusercontent.com/hexschool/Resume/master/findJob.json';
  getWorkAjax = function() {
    return $.getJSON(workUrl);
  };
  getProfileAJAX = function() {
    return $.getJSON(profileUrl);
  };
  $.when(getWorkAjax(), getProfileAJAX()).done(function(workResult1, profileResult2) {
    resume.profileUserData = profileResult2[0];
    optionArea(profileResult2[0]);
    getWorkPeple(workResult1[0]);
    switch (resume.status) {
      case '1':
        return updateProfile(profileResult2[0], resume.zone);
      case '2':
        return updateProfile(profileResult2[0], null, resume.job);
      case '3':
        return updateProfile(profileResult2[0], resume.zone, resume.job);
      default:
        return updateProfile(profileResult2[0]);
    }
  }).catch(function(error) {
    console.log(error.responseText);
  });
};

optionArea = function(data) {
  var newArea;
  if (resume.status === '0') {
    newArea = filterArea(data);
    return newArea.forEach(function(item) {
      var options;
      options = document.createElement('option');
      options.textContent = item;
      return area.appendChild(options);
    });
  } else {
    return areaID.remove();
  }
};

filterArea = function(data) {
  var cache, newArea, profile;
  profile = data;
  cache = [];
  newArea = [];
  profile.forEach(function(item) {
    return cache = cache.concat(item.location);
  });
  newArea = cache.filter(function(item, index) {
    return cache.indexOf(item) === index;
  });
  return newArea;
};

updateProfile = function(profileData, area, job) {
  var newArea, profile, str;
  str = '';
  console.log(resume);
  profile = profileData;
  newArea = filterArea(profile);
  switch (resume.status) {
    case '1':
      str += hopeArea(area);
      profile.forEach(function(profileItem) {
        return profileItem.location.forEach(function(item) {
          if (item === area && profileItem.profileUrl) {
            return str += profileCard(profileItem);
          }
        });
      });
      profile.forEach(function(profileItem) {
        return profileItem.location.forEach(function(item) {
          if (item === area && !profileItem.profileUrl) {
            return str += profileCard(profileItem);
          }
        });
      });
      app.innerHTML = str;
      break;
    case '2':
      profile.forEach(function(profileItem) {
        return profileItem.job.forEach(function(itemJob) {
          if (itemJob === job && profileItem.profileUrl) {
            return str += profileCard(profileItem);
          }
        });
      });
      profile.forEach(function(profileItem) {
        return profileItem.job.forEach(function(itemJob) {
          if (itemJob === job && !profileItem.profileUrl) {
            return str += profileCard(profileItem);
          }
        });
      });
      app.innerHTML = str;
      break;
    case '3':
      str += hopeArea(area);
      profile.forEach(function(profileItem) {
        return profileItem.location.forEach(function(itemArea) {
          return profileItem.job.forEach(function(itemJob) {
            if (itemArea === area && itemJob === job && profileItem.profileUrl) {
              return str += profileCard(profileItem);
            }
          });
        });
      });
      profileData.forEach(function(profileItem) {
        return profileItem.location.forEach(function(itemArea) {
          return profileItem.job.forEach(function(itemJob) {
            if (itemArea === area && itemJob === job && !profileItem.profileUrl) {
              return str += profileCard(profileItem);
            }
          });
        });
      });
      app.innerHTML = str;
      break;
    default:
      newArea.forEach(function(area) {
        str += hopeArea(area);
        profile.forEach(function(item) {
          var a;
          a = item.location.some(function(val) {
            return val === area;
          });
          if (a && item.profileUrl) {
            return str += profileCard(item);
          }
        });
        return profile.forEach(function(item) {
          var a;
          a = item.location.some(function(val) {
            return val === area;
          });
          if (a && !item.profileUrl) {
            return str += profileCard(item);
          }
        });
      });
      app.innerHTML = str;
  }
};

getWorkPeple = function(data) {
  return workID.innerHTML = `有 ${resume.hasWorkCount + data.length} 位學員透過六角成功就業囉`;
};

hopeArea = function(area) {
  return `<div class='col-md-12'> <h3> <i class='fas fa-map-marker-alt text-primary'></i> 他們希望在 <span class='text-primary'>${area}</span> 工作 </h3> <hr/> </div>`;
};

profileCard = function(item) {
  return `<div class='col-md-6 my-2'> <div class='card h-100'> <div class='card-body'> <div class='row flex-row-reverse h-100'> <div class='col-lg-5'> <div class='d-flex flex-column align-items-center'> <div class='profile-user-img-mobile d-md-none' style='background-image: url(${item.imgUrl})'></div> <div class='profile-user-img d-md-block d-none' style='background-image: url(${item.imgUrl})'></div> <div class='profile-type text-nowrap smail text-muted'> ${item.type.map(function(itemType) {
    return `<span>${itemType}</span>`;
  }).join(' / ')} </div> ${(item.experience !== 0 ? `<div class='text-muted'>工作經歷 ${item.experience} 年</div>` : '')} </div> </div> <div class='col-lg-7 d-flex flex-column'> <h5 class='card-title font-weight-bold'>${item.name}</h5> <div class='profile-location small text-muted'> <i class='fas fa-map-marker-alt'></i> ${item.location.map(function(itemLocation) {
    return `<span>${itemLocation}</span>`;
  }).join(' / ')} </div> <div class='text-left'>${item.job}</div> <p class='card-text profile-description text-muted'>${item.description}</p> <div class='profile-tags small text-muted mt-auto'> ${item.tags.map(function(itemTages) {
    return `<span class='d-inline-block'>${itemTages}</span>`;
  }).join(' / ')} </div> <div class='profile-connect'> ${(item.profileUrl ? `<a href='${item.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a>` : "<a href='#' class='btn btn-outline-success btn-block mt-2 disabled' tabindex='-1' role='button' aria-disabled='true'><i class='fab fa-angellist'></i> 成功媒合！</a>")} </div> </div> </div> </div> </div> </div>`;
};

scrollTopClick = function(e) {
  e.preventDefault();
  return window.scrollTo({
    top: 0,
    behavior: "smooth"
  });
};

getUrlQueryString();

getProfile();

window.addEventListener('scroll', function() {
  if (window.scrollY > 100) {
    return scrollTopID.style.opacity = '1';
  } else {
    return scrollTopID.style.opacity = '0';
  }
});

areaID.addEventListener('change', function(e) {
  resume.status = '1';
  if (e.target.value === '全部') {
    return updateProfile(resume.profileUserData);
  } else {
    return updateProfile(resume.profileUserData, e.target.value);
  }
});

scrollTopID.addEventListener('click', scrollTopClick);

//# sourceMappingURL=index.js.map
